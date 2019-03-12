//
//  ModifyPwViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "ModifyPwViewController.h"

@interface ModifyPwViewController ()

@end

@implementation ModifyPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    if (self.forPayPw) {
        self.title = @"修改支付密码";
    }
    else
        self.title = @"修改密码";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAct:(UIButton *)sender {
    if (![self.reNewPw.text isEqualToString:self.npw.text]) {
        [AlertHelper showAlertWithTitle:@"密码不一致"];
        return;
    }
    if (self.forPayPw) {
        [SVProgressHUD show];
        [[ServiceForUser manager]postMethodName:@"" params:@{@"paypwd":self.pw.text,@"new_paypwd":self.npw.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                [AlertHelper showAlertWithTitle:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else [AlertHelper showAlertWithTitle:error];
        }];
    }
    else
    {
        [SVProgressHUD show];
        [[ServiceForUser manager]postMethodName:@"" params:@{@"password":self.npw.text,@"old_password":self.pw.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                [AlertHelper showAlertWithTitle:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else [AlertHelper showAlertWithTitle:error];
        }];
    }
}
@end
