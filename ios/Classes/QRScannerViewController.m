//
//  QRScannerViewController.m
//  QiQRCode
//
//  Created by Benster on 2020/12/18.
//  Copyright © 2020 QiShare. All rights reserved.
//

#import "QRScannerViewController.h"
#import "QiCodePreviewView.h"
#import "QiCodeManager.h"

#define STATUS_BAR_HEIGHT                   ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NAVIGATION_BAR_HEIGHT               (44)
#define STATUS_AND_NAVIGATION_BAR_HEIGHT    ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)

@interface QRScannerViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, assign) bool isHiddend;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *photoLibaryButton;

@property (nonatomic, strong) QiCodePreviewView *previewView;
@property (nonatomic, strong) QiCodeManager *codeManager;

@end

@implementation QRScannerViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isHiddend = [self.navigationController isNavigationBarHidden];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isHiddend) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [_codeManager stopScanning];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor blackColor];
    
    _previewView = [[QiCodePreviewView alloc] initWithFrame:self.view.bounds];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_previewView];
    __weak typeof(self) weakSelf = self;
    _codeManager = [[QiCodeManager alloc] initWithPreviewView:_previewView completion:^{
        [weakSelf startScanning];
    }];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[self imageNamed:@"white_back"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT + 10, 60, 40);
    [self.backButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.photoLibaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoLibaryButton.frame = CGRectMake(SCREEN_WIDTH - 60, STATUS_BAR_HEIGHT + 10, 60, 40);
    [self.photoLibaryButton setTitle:@"相册" forState:UIControlStateNormal];
    [self.photoLibaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.photoLibaryButton addTarget:self action:@selector(photoLibaryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoLibaryButton];
}

- (UIImage *)imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}


#pragma mark - Action functions

- (void)photoLibaryAction {
    __weak typeof(self) weakSelf = self;
    [_codeManager presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull code) {
        [weakSelf scanSuccessAction:code];
    }];
}

- (void)popAction {
    !self.scanSuccessCallback ?: self.scanSuccessCallback(@"");
    [self backAction];
}

- (void)backAction {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)scanSuccessAction:(NSString *)codeText {
    if (!codeText ||
        [codeText isKindOfClass:NSNull.class] ||
        ![codeText isKindOfClass:NSString.class] ||
        [codeText  isEqualToString: @""])
    {
        return;
    }
    
    !self.scanSuccessCallback ?: self.scanSuccessCallback(codeText);
    [self backAction];
}


#pragma mark - Private functions

- (void)startScanning {
    __weak typeof(self) weakSelf = self;
    [_codeManager startScanningWithCallback:^(NSString * _Nonnull code) {
        [weakSelf scanSuccessAction:code];
    } autoStop:YES];
}


@end
