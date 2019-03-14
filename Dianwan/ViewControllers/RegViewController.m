//
//  RegViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    self.title = @"注册";
    
    [[ServiceForUser manager]getMethodName:@"Login/get_inviter/index.html" params:@{@"inviter_id":@"0"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            self.recommendCode.text = [[[data safeDictionaryForKey:@"result"] safeDictionaryForKey:@"member"] safeStringForKey:@"invite_code"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self.passWord.text isEqualToString:self.inviteCode.text]) {
        [AlertHelper showAlertWithTitle:@"密码不一致"];
        return;
    }
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"Connect/sms_register.html" params:@{@"phone":self.phone.text,@"password":self.passWord.text,@"captcha":self.code.text,@"inviter_id":self.recommendCode.text,@"client":@"ios"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [SVProgressHUD show];
            //注册成功后执行登录
            [[ServiceForUser manager]postMethodName:@"Login/index.html" params:@{@"username":self.phone.text,@"password":self.passWord.text,@"client":@"ios"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
                [SVProgressHUD dismiss];
                if (status) {
                    [HTTPClientInstance saveToken:[[data safeDictionaryForKey:@"result"] safeStringForKey:@"key"] uid:[[data safeDictionaryForKey:@"result"] safeStringForKey:@"userid"]];
                    AppDelegateInstance.defaultUser = [User insertOrReplaceWithDictionary:[data safeDictionaryForKey:@"result"] context:AppDelegateInstance.managedObjectContext];
                    [AppDelegateInstance showMainPage];
                }
                else [AlertHelper showAlertWithTitle:error];
            }];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}

- (IBAction)getCodeAct:(UIButton *)sender {
    [[ServiceForUser manager]postMethodName:@"Connect/get_sms_captcha.html" params:@{@"phone":self.phone.text,@"type":@"1"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            sender.enabled = NO;
            __block int i = 60;
            NSTimer *codeTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                i--;
                sender.titleLabel.text = [NSString stringWithFormat:@"%d秒倒计时",i];
                [sender setTitle:[NSString stringWithFormat:@"%d秒倒计时",i] forState:UIControlStateNormal];
                if (i==0) {
                    [timer invalidate];
                    sender.enabled = YES;
                    [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                }
            }];
            [[NSRunLoop mainRunLoop] addTimer:codeTimer forMode:NSDefaultRunLoopMode];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}
@end
