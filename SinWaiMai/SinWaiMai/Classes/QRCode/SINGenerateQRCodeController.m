//
//  SINGenerateQRCodeController.m
//  QRCode
//
//  Created by apple on 23/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINGenerateQRCodeController.h"
#import "SINQRCodeTool.h"
#import "Masonry.h"
#import "SINQRCodeConst.h"
#import <Photos/Photos.h>

@interface SINGenerateQRCodeController ()

@property (nonatomic,strong) UIImageView *QRCodeView;

@property (nonatomic,strong) UIButton *changeStyleBtn;

@property (nonatomic,strong) UIButton *saveToAblumBtn;

@end

@implementation SINGenerateQRCodeController
#pragma mark - View Controller Enter
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self layoutChildView];
    
    // 显示默认二维码
    [self iconQRCode];
}

#pragma mark - 生成二维码
- (void)defaultQRCode
{
    self.QRCodeView.image = [SINQRCodeTool sin_generateWithDefaultQRCodeData:@"https://github.com/Sinalma" imageViewWidth:self.QRCodeView.frame.size.width];

#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
    /*
    CGFloat imageViewW = self.QRCodeView.frame.size.width;
    CGFloat imageViewH = self.QRCodeView.frame.size.height;
    CGFloat scale = 0.22;
    CGFloat borderW = 5;
    UIView *borderView = [[UIView alloc] init];
    CGFloat borderViewW = imageViewW * scale;
    CGFloat borderViewH = imageViewH * scale;
    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
    borderView.layer.borderWidth = borderW;
    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
    borderView.layer.cornerRadius = 10;
    borderView.layer.masksToBounds = YES;
    borderView.layer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    
    [self.QRCodeView addSubview:borderView];
     */
}

/** 中间带图标的二维码 */
- (void)iconQRCode
{
    CGFloat scale = 0.2;
    
    self.QRCodeView.image = [SINQRCodeTool sin_generateWithLogoQRCodeData:@"https://github.com/Sinalma" logoImageName:@"logo" logoScaleToSuperView:scale];
}

/** 彩色二维码 */
- (void)colorfulQRCode
{
    self.QRCodeView.image = [SINQRCodeTool sin_generateWithColorQRCodeData:@"https://github.com/Sinalma" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
}

/** 检查是否生成二维码成功，失败则重新生成 */
- (void)verifyIsHaveImg
{
    if (!self.QRCodeView.image) {
        [self changeQRCodeStyle];
    }
}

// 默认二维码样式 0
static int QRCodeStyleFlag = 0;
#pragma mark - Monitor Events
- (void)changeQRCodeStyle
{
    self.QRCodeView.image = nil;
    
    if (QRCodeStyleFlag >= 3) {
        QRCodeStyleFlag = 0;
    }
    switch (QRCodeStyleFlag) {
        case 0:
            [self defaultQRCode];
            break;
        case 1:
            [self iconQRCode];
            break;
        case 2:
            [self colorfulQRCode];
            break;
    }
    
    QRCodeStyleFlag += 1;
    [self verifyIsHaveImg];
}

- (void)saveQRCodeToAlbum
{
    if (!self.QRCodeView.image) {
        SINLog(@"保存失败，没有二维码");
        return;
    }
     UIImageWriteToSavedPhotosAlbum(self.QRCodeView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
//    SINLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - Set Up
- (void)layoutChildView
{
    [self.view addSubview:self.QRCodeView];
    [self.view addSubview:self.changeStyleBtn];
    [self.view addSubview:self.saveToAblumBtn];
    
    CGFloat leftMargin = 30;
    CGFloat topMargin = 20;
    CGFloat VWH = SINScreenW - leftMargin * 2;
    
    [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftMargin);
        make.top.equalTo(self.view).offset(topMargin + 64);
        make.width.height.equalTo(@(VWH));
    }];
    
    CGFloat btnWH = 75;
    CGFloat btnTopMargin = (SINScreenW - 64 - CGRectGetMaxY(self.QRCodeView.frame)) * 0.5 - (btnWH * 0.5) ;
    
    [self.changeStyleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRCodeView.mas_bottom).offset(btnTopMargin);
        make.left.equalTo(self.QRCodeView);
        make.width.height.equalTo(@(btnWH));
    }];
    
    [self.saveToAblumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeStyleBtn);
        make.right.equalTo(self.QRCodeView);
        make.width.height.equalTo(@(btnWH));
    }];
    self.QRCodeView.backgroundColor = [UIColor greenColor];
}

- (void)setup
{
    self.view.backgroundColor = SINQRCodeNormalColor;
}

#pragma mark - Lazying Load 
- (UIImageView *)QRCodeView
{
    if (!_QRCodeView) {
        _QRCodeView = [[UIImageView alloc] init];
    }
    return _QRCodeView;
}

- (UIButton *)changeStyleBtn
{
    if (!_changeStyleBtn) {
        _changeStyleBtn = [[UIButton alloc] init];
        [_changeStyleBtn setTitle:@"换个样式" forState:UIControlStateNormal];
        [_changeStyleBtn addTarget:self action:@selector(changeQRCodeStyle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeStyleBtn;
}

- (UIButton *)saveToAblumBtn
{
    if (!_saveToAblumBtn) {
        _saveToAblumBtn = [[UIButton alloc] init];
        [_saveToAblumBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveToAblumBtn addTarget:self action:@selector(saveQRCodeToAlbum) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveToAblumBtn;
}

@end
