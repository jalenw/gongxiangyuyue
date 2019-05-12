//
//  AlertHelper.m
//  Ekeo2
//
//  Created by Roger on 13-8-29.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import "AlertHelper.h"
#import "BlockUIAlertView.h"
#import "SVProgressHUD.h"
#import "NSError+Helper.h"
#import "LZHAlertView.h"
@implementation AlertHelper

+ (NSMutableArray*)alertQueue
{
    static NSMutableArray *_alertQueueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alertQueueInstance = [[NSMutableArray alloc] init];
    });
    
    return _alertQueueInstance;
}

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    if (message == nil)
    {
        [self showAlertWithTitle:title];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

+ (void)showAlertWithTitle:(NSString*)title
{
    
    if ([title isEqualToString:@"请登录"]) {
        LZHAlertView *alertView = [LZHAlertView shareInstanceForLogin];
        alertView.contentLabel.text = @"登录凭证失效，请重新登录";
        alertView.titleLabel.text = @"提示";
        __weak LZHAlertView *weakAlert = alertView;
        [alertView setBlock:^(NSInteger index, NSString *title) {
            [weakAlert hide];
            [AppDelegateInstance logout];
            
        }];
        
        [alertView show];
        return;
        
        
    }
    
    if (title && title.length > 0) {
        [SVProgressHUD showImage:nil status:title];
    }else{
        [SVProgressHUD showImage:nil status:@"网络异常"];
    }
}

+(void)showAlertWithTitle:(NSString *)title duration:(NSTimeInterval)duration
{
    [SVProgressHUD showImage:nil status:title duration:duration];
}
@end
