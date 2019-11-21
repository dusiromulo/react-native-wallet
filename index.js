import { NativeModules } from 'react-native';

const { Wallet } = NativeModules;

import { _canAddPasses, _showAddPassControllerFromURL, _showAddPassControllerFromFile } from './src/platform-specific';

/**
 * Check if you can add passes.
 * @param callback A callback which will receive a boolean
 */
function canAddPasses(callback) {
    _canAddPasses(Wallet, callback);
}

/**
 * Show the pass controller for the provided URL.
 * The resolving promise will contain a boolean saying if the pass was added or not.
 * @param passURL URL to pkpass file
 * @return Promise Passing a boolean
 */
function showAddPassControllerFromURL(passURL) {
    return _showAddPassControllerFromURL(Wallet, passURL);
}

/**
 * Show the pass controller for the provided filepath.
 * The resolving promise will contain a boolean saying if the pass was added or not.
 * @param filepath File path pkpass file
 * @return Promise Passing a boolean
 */
function showAddPassControllerFromFile(filepath) {
    return _showAddPassControllerFromFile(Wallet, filepath);
}

export { canAddPasses, showAddPassControllerFromURL, showAddPassControllerFromFile };
