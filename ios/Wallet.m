#import "Wallet.h"
#import <PassKit/PassKit.h>

static NSString *const kRejectCode = @"wallet";

@interface Wallet() <PKAddPassesViewControllerDelegate>

@property (nonatomic, copy) RCTPromiseResolveBlock resolveBlock;
@property (nonatomic, strong) PKPass *pass;
@property (nonatomic, strong) PKPassLibrary *passLibrary;

@end

@implementation Wallet

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(canAddPasses:(RCTResponseSenderBlock)callback) {
	callback(@[@([PKAddPassesViewController canAddPasses])]);
}

RCT_EXPORT_METHOD(
                  showAddPassControllerFromFile:(NSString *)filepath
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  ) {
    NSData* data =[[NSData alloc]init];

    data = [NSData dataWithContentsOfFile:filepath];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self showViewControllerWithData:data resolver:resolve rejecter:reject];
    });

}

RCT_EXPORT_METHOD(
	showAddPassControllerFromURL:(NSString *)pass
	resolver:(RCTPromiseResolveBlock)resolve
	rejecter:(RCTPromiseRejectBlock)reject
) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSURL *passURL = [[NSURL alloc] initWithString:pass];
		if (!passURL) {
			reject(kRejectCode, @"The pass URL is invalid", nil);
			return;
		}

		NSData *data = [[NSData alloc] initWithContentsOfURL:passURL];
		if (!data) {
			reject(kRejectCode, @"The pass data is invalid", nil);
			return;
		}

		[self showViewControllerWithData:data resolver:resolve rejecter:reject];
	});
}

- (void)showViewControllerWithData:(NSData *)data
                          resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject {
    NSError *passError;
    self.pass = [[PKPass alloc] initWithData:data error:&passError];

    if (passError) {
        reject(kRejectCode, @"The pass is invalid", passError);
        return;
    }

    self.passLibrary = [[PKPassLibrary alloc] init];
    [self.passLibrary removePass:self.pass];

    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    PKAddPassesViewController *passController = [[PKAddPassesViewController alloc] initWithPass:self.pass];
    passController.delegate = self;
    self.resolveBlock = resolve;

    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    [viewController presentViewController:passController animated:YES completion:nil];
}

#pragma mark - PKAddPassesViewControllerDelegate

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
	[controller dismissViewControllerAnimated:YES completion:^{
		if (self.resolveBlock) {
			self.resolveBlock(@([self.passLibrary containsPass:self.pass]));
            self.resolveBlock = nil;
		}

		controller.delegate = nil;
		self.passLibrary = nil;
		self.pass = nil;
	}];
}

@end
