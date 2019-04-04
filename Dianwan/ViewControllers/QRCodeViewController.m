//
//  QRCodeViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ShareHelper.h"
#import <ShareSDK/ShareSDK.h>

@interface QRCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *recommendedCodeLabel;
@property(nonatomic,strong)NSString *url;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageview;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的推荐码";
    self.codeImageview.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longges = [[UILongPressGestureRecognizer alloc ]initWithTarget:self action:@selector(longClick)];
    [self.codeImageview addGestureRecognizer:longges];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[ServiceForUser manager]postMethodName:@"index/get_inviter_id" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            [filter setDefaults];
            NSData *d = [[[data safeDictionaryForKey:@"result"] safeStringForKey:@"url"] dataUsingEncoding:NSUTF8StringEncoding];
            [filter setValue:d forKey:@"inputMessage"];
            [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
            CIImage *outPutImage = [filter outputImage];
            [self.imgView setImage:[self sencond_getHDImgWithCIImage:outPutImage size:self.imgView.size]];
            self.recommendedCodeLabel.text =[NSString stringWithFormat:@"推荐码：%@", [[data safeDictionaryForKey:@"result"] safeStringForKey:@"code"]];
            self.url =[[data safeDictionaryForKey:@"result"] safeStringForKey:@"url"];
            
        }
        else
            [AlertHelper showAlertWithTitle:error];
    }];
}

- (UIImage *)sencond_getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

-(void)longClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ShareHelper showShareCommonViewWithTitle:@"我的二维码" content:@"" images: @[self.codeImageview.image] description:@"和约" url:self.url andViewTitle:@"和约" andViewDes:@"合约" result:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [AlertHelper showAlertWithTitle:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [ShareHelper showShareFailHintWithError:error];
                break;
            }
            default:
                break;
        }
    } block:^(NSInteger index) {
    }];
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image =self.codeImageview.image  ;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"识别图中二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"识别二维码");
//        CIContext *context = [[CIContext alloc] init];
//        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
//        CIImage *imageCI = [[CIImage alloc] initWithImage:self.codeImageview.image];
//        NSArray *features = [detector featuresInImage:imageCI];
//        CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
        CommonUIWebViewController *safariVC = [[CommonUIWebViewController alloc] init];
        safariVC.address = self.url;
        [self.navigationController pushViewController:safariVC animated:YES];
        
        
    }]];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"保存相册成功"];
}

@end
