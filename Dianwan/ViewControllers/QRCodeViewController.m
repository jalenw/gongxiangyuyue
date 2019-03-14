//
//  QRCodeViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的推荐码";
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
