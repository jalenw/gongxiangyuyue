//
//  QRViewController.h
//  WebServer
//
//  Created by 黄哲麟 on 2018/3/8.
//  Copyright © 2018年 黄哲麟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QRViewControllerDelegate<NSObject>
//二维码扫描后返回结果
-(void)qrReturnString:(NSString*)str;
@end
@interface QRViewController : BaseViewController
@property (weak,nonatomic) id<QRViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
