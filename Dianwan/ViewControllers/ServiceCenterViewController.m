//
//  ServiceCenterViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "ServiceCenterViewController.h"
#import "JsonHelper.h"
@interface ServiceCenterViewController ()

@end

@implementation ServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[ServiceForUser manager]postMethodName:@"index/kefu" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [self.img sd_setImageWithURL:[NSURL URLWithString:[[data safeDictionaryForKey:@"result"] safeStringForKey:@"qrcode"]]];
            NSMutableString *wx = [[NSMutableString alloc]init];
            for (NSString *str in [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"wx"]) {
                [wx appendString:str];
                [wx appendString:@"\n"];
            }
            self.wxLb.text =[NSString stringWithFormat:@"微信号：%@", wx];
            [self.wxLb sizeToFit];
            self.wxLb.width = ScreenWidth-48-48;
            NSMutableString *qq = [[NSMutableString alloc]init];
            for (NSString *str in [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"qq"]) {
                [qq appendString:str];
                [qq appendString:@"\n"];
            }
            self.qqLb.text =[NSString stringWithFormat:@"QQ号：%@", qq];
            [self.qqLb sizeToFit];
             self.qqLb.width = ScreenWidth-48-48;
            self.qqLb.top = self.wxLb.bottom + 8;
            
            NSMutableString *mobile = [[NSMutableString alloc]init];
            for (NSString *str in [[data safeDictionaryForKey:@"result"] safeArrayForKey:@"mobile"]) {
                [mobile appendString:str];
                [mobile appendString:@"\n"];
            }
            self.phoneLb.text =[NSString stringWithFormat:@"手机号：%@", mobile];
            [self.phoneLb sizeToFit];
             self.phoneLb.width = ScreenWidth-48-48;
            self.phoneLb.top = self.qqLb.bottom + 8;
        }
        else
            [AlertHelper showAlertWithTitle:error];
    }];
}
@end
