//
//  QRViewController.m
//  WebServer
//
//  Created by 黄哲麟 on 2018/3/8.
//  Copyright © 2018年 黄哲麟. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "QRFrameView.h"
@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL hasValue;
}
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    NSArray *allDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

    self.input = [AVCaptureDeviceInput deviceInputWithDevice:[allDevice firstObject] error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];

    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    self.session = [[AVCaptureSession alloc]init];


    if ([self.session canAddInput:self.input]) {

        [self.session addInput:self.input];

    }

    if ([self.session canAddOutput:self.output]) {

        [self.session addOutput:self.output];

    }


    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    [self.session setSessionPreset:AVCaptureSessionPresetHigh];

    self.layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.layer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.contentView.layer addSublayer:self.layer];
    
    [self.session startRunning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:maskView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 130, ScreenWidth - 100, 300) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    QRFrameView *qrView = [[QRFrameView alloc] initWithFrame:CGRectMake(50, 130, ScreenWidth - 100, 300)];
    qrView.color = [UIColor blueColor];
    qrView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:qrView];
    
    UIView *line = [[UIView alloc] initWithFrame: CGRectMake(55, 135, ScreenWidth - 110, 2)];
    
    line.backgroundColor =  [UIColor blueColor];
    
    [self.view addSubview:line];

    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        line.frame = CGRectMake(55, 135+290, ScreenWidth - 110, 2);
        
    } completion:nil];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    AVMetadataMachineReadableCodeObject *objc = [metadataObjects firstObject];
    NSString *str = objc.stringValue;
    if (str!=nil&&!hasValue) {
        hasValue = true;
        NSLog(@"%@",str);
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate qrReturnString:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
