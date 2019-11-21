#import "Wallet.h"
#import <PassKit/PassKit.h>

@interface Wallet() <PKAddPassesViewControllerDelegate>

@property (nonatomic, copy) RCTPromiseResolveBlock resolveBlock;
@property (nonatomic, strong) PKPass *pass;
@property (nonatomic, strong) PKPassLibrary *passLibrary;

@end

@implementation Wallet

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod2:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

RCT_EXPORT_METHOD(canAddPasses:(RCTResponseSenderBlock)callback) {
	callback(@[@([PKAddPassesViewController canAddPasses])]);
}

@end
