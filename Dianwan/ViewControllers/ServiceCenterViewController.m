//
//  ServiceCenterViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "ServiceCenterViewController.h"

@interface ServiceCenterViewController ()

@end

@implementation ServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[ServiceForUser manager]postMethodName:@"index/kefu" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            [filter setDefaults];
            NSData *d = [[[data safeDictionaryForKey:@"result"] safeStringForKey:@"qrcode"] dataUsingEncoding:NSUTF8StringEncoding];
            [filter setValue:d forKey:@"inputMessage"];
            [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
            CIImage *outPutImage = [filter outputImage];
            [self.img setImage:[self sencond_getHDImgWithCIImage:outPutImage size:self.img.size]];
            self.wxLb.text =[NSString stringWithFormat:@"微信号：%@", [[data safeDictionaryForKey:@"result"] safeStringForKey:@"wx"]];
            self.qqLb.text =[NSString stringWithFormat:@"QQ号：%@", [[data safeDictionaryForKey:@"result"] safeStringForKey:@"qq"]];
            self.phoneLb.text =[NSString stringWithFormat:@"手机号：%@", [[data safeDictionaryForKey:@"result"] safeStringForKey:@"mobile"]];
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

@end
