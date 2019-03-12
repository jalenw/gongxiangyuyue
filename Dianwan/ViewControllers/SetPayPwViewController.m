//
//  SetPayPwViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "SetPayPwViewController.h"

@interface SetPayPwViewController ()

@end

@implementation SetPayPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置支付密码";
    [self setupForDismissKeyboard];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAct:(UIButton *)sender {
    if (![self.pw.text isEqualToString:self.rpw.text]) {
        [AlertHelper showAlertWithTitle:@"密码不一致"];
        return;
    }
        [SVProgressHUD show];
        [[ServiceForUser manager]postMethodName:@"" params:@{@"member_paypwd":self.pw.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                [AlertHelper showAlertWithTitle:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else [AlertHelper showAlertWithTitle:error];
        }];
}
@end
