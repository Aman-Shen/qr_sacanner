//
//  QRScannerViewController.h
//  QiQRCode
//
//  Created by Benster on 2020/12/18.
//  Copyright © 2020 QiShare. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScannerViewController : UIViewController

// 扫码回调
@property (nonatomic, copy) void (^scanSuccessCallback)(NSString *codeText);

@end

NS_ASSUME_NONNULL_END
