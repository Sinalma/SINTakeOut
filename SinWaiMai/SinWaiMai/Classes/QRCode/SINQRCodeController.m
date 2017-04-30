//
//  SINQRCodeController.m
//  QRCode
//
//  Created by apple on 21/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINQRCodeController.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "SINQRCodeConst.h"
#import "SINQRCodeShowController.h"
#import <Photos/Photos.h>
#import "UIImage+SINHelper.h"
#import "SINGenerateQRCodeController.h"

@interface SINQRCodeController () <AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIView *QRGobalView;
@property (nonatomic,strong) UIView *QRInnerView;
@property (nonatomic,strong) UILabel *remindLabel;
@property (nonatomic,strong) UIImageView *myQRCodeView;
@property (nonatomic,strong) UILabel *myQRCodeLabel;
@property (nonatomic,strong) UIImageView *QRScanLine;
@property (nonatomic,strong) NSTimer *scanLineTimer;

// 会话对象
@property (nonatomic,strong) AVCaptureSession *session;

// 预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation SINQRCodeController
#pragma mark - 入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self layoutChildView];
    
    if ([self verifyScanDevice]) {
        
        [self setupScanningQRCode];
        [self startScanQRCodeTimer];
    }
}

static BOOL flag = YES;
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (flag) {
        flag = NO;
        
        return;
    }
    
    if ([self verifyScanDevice]) {
       
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
        [self.session startRunning];
        [self startScanQRCodeTimer];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.scanLineTimer invalidate];
    self.scanLineTimer = nil;
    
    CGRect frame = self.QRScanLine.frame;
    frame.origin.y = 0;
    self.QRScanLine.frame = frame;
}

#pragma mark - 自定义方法
/** >>>>>>>>>>>>相机扫描>>>>>>>>>>>>>>. */
/**
 * 检测相机
 */
- (BOOL )verifyScanDevice
{
    // 获取摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{

                        //
                    });
                    NSLog(@"用户第一次同意了访问相机权限");
                }
            }];
            return YES;
        
        }else if (status == AVAuthorizationStatusAuthorized){
            
            // 用户允许当前应用访问相机
            //
            
            return YES;
            
        }else if (status == AVAuthorizationStatusDenied){
            
            // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            return NO;
            
        }else if (status == AVAuthorizationStatusRestricted){
            NSLog(@"因系统原因，无法访问相册");
            return NO;
        }
        
    }else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    return NO;
}

- (void)setupScanningQRCode
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 设置代理，在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    output.rectOfInterest = CGRectMake(0.05,0.2,0.7, 0.6);
    
    // 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 添加会话输入
    [_session addInput:input];
    
    // 添加会话输出
    [_session addOutput:output];
    
    // 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元素类型，否则会报错
    // 设置扫码支持的编码格式（如下设置条形码和二维码兼容）
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    // 实例化预览图层，传递——session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    // 将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 启动会话
    [_session startRunning];
}

/**
 * 开启定时器
 */
- (void)startScanQRCodeTimer
{
    self.scanLineTimer = [NSTimer scheduledTimerWithTimeInterval:SINScanQRCodeTime target:self selector:@selector(scanLineTimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.scanLineTimer forMode:NSRunLoopCommonModes];
}

- (void)scanLineTimeAction
{
    [UIView animateWithDuration:SINScanQRCodeTime-0.1 animations:^{
        self.QRScanLine.hidden = NO;
        CGRect frame = self.QRScanLine.frame;
        frame.origin.y = self.QRInnerView.frame.size.height-10;
        self.QRScanLine.frame = frame;
    } completion:^(BOOL finished) {
        CGRect frame = self.QRScanLine.frame;
        frame.origin.y = 5;
        self.QRScanLine.frame = frame;
        self.QRScanLine.hidden = YES;
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 提示音
    [self playRemindSoundWithName:@"sound"];
    
    // 停止会话
    [self.session stopRunning];
    
    // 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *objc = metadataObjects[0];
        
        // 发通知
//        [SINNotiCenter postNotificationName:SINQRCodeInfoNotiFromScan object:objc.stringValue];
        
        NSString *QRCodeInfo = objc.stringValue;
        [self jumpResultShowVC:QRCodeInfo];
     }
}

- (void)jumpResultShowVC:(NSString *)resultInfo
{
    if ([resultInfo hasPrefix:@"http"]) {
        SINQRCodeShowController *showVC = [[SINQRCodeShowController alloc] init];
        showVC.QR_code = resultInfo;
        [self.navigationController pushViewController:showVC animated:YES];
    }else
    {
        SINQRCodeShowController *showVC = [[SINQRCodeShowController alloc] init];
        showVC.Bar_code = resultInfo;
        [self.navigationController pushViewController:showVC animated:YES];
    }

}

/**
 * 播放音效文件
 */
- (void)playRemindSoundWithName:(NSString *)name
{
//    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:name];
    
    // 声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
}
/** 播放完成回调函数 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成");
}

/** >>>>>>>>>>>>>>>>>相册>>>>>>>>>>>>>>>>> */
- (void)ablum
{
    [self readQRCodeFromAlbum];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"info = imge = %@",img);
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:img];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 从相册中识别二维码，并进行界面跳转
 */
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image
{
    // 处理图片过大
    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSLog(@"%@",features);
    for (int index = 0; index < [features count]; index++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        NSLog(@"scannedResult -> %@",scannedResult);
        // 拿到二维码结果，进行界面跳转
        
        [self jumpResultShowVC:scannedResult];
    }
}

- (void)readQRCodeFromAlbum
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device) {
        
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        // 未做出选择
        if (status == PHAuthorizationStatusNotDetermined) {
            
            // 弹框请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                // 用户第一次同意了访问相册权限
                if (status == PHAuthorizationStatusAuthorized) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 从相册中选取
                        imgPicker.delegate = self;
                        [self presentViewController:imgPicker animated:YES completion:nil];
                    });
                }else
                {
                    // 用户第一次拒绝了访问相机权限
                }
                
            }];
        }else if (status == PHAuthorizationStatusAuthorized)
        {
            // 用户允许当前应用访问相册
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // 从相册中选取
            imgPicker.delegate = self;
            [self presentViewController:imgPicker animated:YES completion:nil];
        }else if (status == PHAuthorizationStatusDenied)
        {
            // 用户拒绝当前应用访问相册
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 照片 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }else if (status == PHAuthorizationStatusRestricted)
        {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}

/** >>>>>>>>>>>>>生成二维码>>>>>>>>>>>>> */
- (void)generateMyQRCode:(UITapGestureRecognizer *)tap
{
    SINGenerateQRCodeController *vc = [[SINGenerateQRCodeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma markr - 初始化
- (void)layoutChildView
{
    int QRWidth = SINScreenW * SINQRCodeViewProportion;
    int QRHeight = QRWidth;
    int QRMargin = (SINScreenW - QRWidth) * 0.5;
    int margin = 10;
    
    [self.view addSubview:self.QRGobalView];
    [self.QRGobalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(QRMargin);
        make.top.equalTo(self.view).offset(64 + margin + 30);
        make.width.equalTo(@(QRWidth));
        make.height.equalTo(@(QRHeight));
    }];
    
    // 四周小方格
    int cubeWH = 30;
    int maxCubeMargin = QRWidth - cubeWH;
    [self cubeWithLMargin:0 TMargin:0 imgN:@"QRCodeLeftTop"];
    [self cubeWithLMargin:0 TMargin:maxCubeMargin imgN:@"QRCodeLeftBottom"];
    [self cubeWithLMargin:maxCubeMargin TMargin:0 imgN:@"QRCodeRightTop"];
    [self cubeWithLMargin:maxCubeMargin TMargin:maxCubeMargin imgN:@"QRCodeRightBottom"];
    
    
    [self.QRGobalView addSubview:self.QRInnerView];
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.myQRCodeView];
    [self.view addSubview:self.myQRCodeLabel];
    [self.QRInnerView addSubview:self.QRScanLine];
    
    [self.QRInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.QRGobalView).offset(4);
        make.bottom.right.equalTo(self.QRGobalView).offset(-4);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QRGobalView);
        make.top.equalTo(self.QRGobalView.mas_bottom).offset(10);
        make.right.equalTo(self.QRGobalView);
        make.height.equalTo(@21);
    }];
    
    [self.myQRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remindLabel.mas_bottom).offset(50);
        make.centerX.equalTo(self.remindLabel);
        make.width.height.equalTo(@100);
    }];
    
    [self.myQRCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QRGobalView);
        make.top.equalTo(self.myQRCodeView.mas_bottom).offset(10);
        make.right.equalTo(self.QRGobalView);
    }];
    
    [self.QRScanLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.QRInnerView);
        make.top.equalTo(self.QRInnerView);
        make.height.equalTo(@12);
    }];
}

- (void)cubeWithLMargin:(CGFloat)LMargin TMargin:(CGFloat)TMargin imgN:(NSString *)imgN
{
    UIImageView *cubeV = [[UIImageView alloc] init];
    cubeV.image = [UIImage imageNamed:imgN];
    [self.QRGobalView addSubview:cubeV];
    [cubeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.QRGobalView).offset(LMargin);
        make.top.equalTo(self.QRGobalView).offset(TMargin);
        make.width.height.equalTo(@30);
    }];
}

- (void)setup
{
//    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:40/255.0 blue:41/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor clearColor];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:36/255.0 green:40/255.0 blue:41/255.0 alpha:0.1]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:36/255.0 green:40/255.0 blue:41/255.0 alpha:0.1]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.title = @"扫一扫";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backAnd"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(ablum)];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

#pragma mark - 懒加载
- (UIView *)QRGobalView
{
    if (!_QRGobalView) {
        _QRGobalView = [[UIView alloc] init];
        _QRGobalView.backgroundColor = [UIColor clearColor];
    }
    return _QRGobalView;
}

- (UIView *)QRInnerView
{
    if (!_QRInnerView) {
        _QRInnerView = [[UIView alloc] init];
//        _QRInnerView.backgroundColor = [UIColor colorWithRed:54/255.0 green:58/255.0 blue:63/255.0  alpha:1.0];
        _QRInnerView.backgroundColor = [UIColor clearColor];
        _QRInnerView.layer.borderColor = [UIColor whiteColor].CGColor;
        _QRInnerView.layer.borderWidth = 1;
    }
    return _QRInnerView;
}

- (UILabel *)remindLabel
{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.text = @"将取景框对准二维码，即可自动扫描";
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.textColor = [UIColor whiteColor];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLabel;
}

- (UIImageView *)myQRCodeView
{
    if (!_myQRCodeView) {
        _myQRCodeView = [[UIImageView alloc] init];
        _myQRCodeView.image = [UIImage imageNamed:@"QRCode"];
        _myQRCodeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generateMyQRCode:)];
        [_myQRCodeView addGestureRecognizer:tap];
    }
    return _myQRCodeView;
}

- (UILabel *)myQRCodeLabel
{
    if (!_myQRCodeLabel) {
        _myQRCodeLabel = [[UILabel alloc] init];
        _myQRCodeLabel.text = @"我的二维码";
        _myQRCodeLabel.font = [UIFont systemFontOfSize:14];
        _myQRCodeLabel.textColor = [UIColor whiteColor];
        _myQRCodeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _myQRCodeLabel;
}

- (UIImageView *)QRScanLine
{
    if (!_QRScanLine) {
        _QRScanLine = [[UIImageView alloc] init];
        _QRScanLine.image = [UIImage imageNamed:@"QRCodeScanningLine"];
    }
    return _QRScanLine;
}
@end
