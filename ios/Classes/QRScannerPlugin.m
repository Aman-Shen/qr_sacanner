#import "QRScannerPlugin.h"
#import "QRScannerViewController.h"

@interface QRScannerPlugin ()

@property (nonatomic, copy) FlutterResult result;

@end

@implementation QRScannerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"qr_scanner"
                                     binaryMessenger:[registrar messenger]];
    QRScannerPlugin* instance = [[QRScannerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.result = result;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        self.result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"scannerCodeResult" isEqualToString:call.method]) {
        [self toScannerPage];
    } else {
        self.result(FlutterMethodNotImplemented);
    }
}

#pragma mark - 打开扫码页面
- (void)toScannerPage {
    QRScannerViewController *scannerVC = [[QRScannerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scannerVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    __weak typeof(self) weakSelf = self;
    scannerVC.scanSuccessCallback = ^(NSString * _Nonnull codeText) {
        NSLog(@"code = %@", codeText);
        weakSelf.result(codeText);
    };
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:nav animated:YES completion:^{}];
}

@end
