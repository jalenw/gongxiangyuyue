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
    else{
        self.title = @"修改登录密码";
       
    }
    
    // Do any additional setup after loading the view from its nib.
}

//获取登录密码修改的验证码
- (IBAction)getLoginCodeAct:(UIButton *)sender {
    [[ServiceForUser manager] postMethodName:@"Memberaccount/modify_password_step2.html" params:@{@"mobile":self.phone.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            sender.enabled = NO;
            __block int i = 60;
            NSTimer *codeTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                i--;
                sender.titleLabel.text = [NSString stringWithFormat:@"%ds后重新获取",i];
                [sender setTitle:[NSString stringWithFormat:@"%ds后重新获取",i] forState:UIControlStateNormal];
                if (i==0) {
                    [timer invalidate];
                    sender.enabled = YES;
                    [sender setTitle:@"验证码" forState:UIControlStateNormal];
                }
            }];
            [[NSRunLoop mainRunLoop] addTimer:codeTimer forMode:NSDefaultRunLoopMode];
        } else [AlertHelper showAlertWithTitle:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAct:(UIButton *)sender {
    if(self.codeTF.text.length==0){
        [AlertHelper showAlertWithTitle:@"验证码为空"];
        return;
    }
    if (![self.reNewPw.text isEqualToString:self.npw.text]) {
        [AlertHelper showAlertWithTitle:@"密码不一致"];
        return;
    }
    if (self.forPayPw) {
        [SVProgressHUD show];
        [[ServiceForUser manager]postMethodName:@"Memberaccount/modify_password_step5.html" params:@{@"password":self.npw.text,@"password1":self.reNewPw.text,@"auth_code":self.codeTF.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
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
        [[ServiceForUser manager]postMethodName:@"Memberaccount/modify_password_step5.html" params:@{@"password":self.npw.text,@"password1":self.reNewPw.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
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
