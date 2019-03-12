//
//  ForgetViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
{
    int i;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phone.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    self.code.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.code.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.password.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    self.rePassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.rePassword.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    [self setupForDismissKeyboard];
    self.title = @"忘记密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAct:(UIButton *)sender {
    [[ServiceForUser manager]postMethodName:@"Connect/get_sms_captcha.html" params:@{@"phone":self.phone.text,@"type":@"3"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            sender.enabled = NO;
            i = 60;
            NSTimer *codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAct:) userInfo:sender repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:codeTimer forMode:NSDefaultRunLoopMode];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}

-(void)timerAct:(NSTimer*)timer
{
    UIButton *sender = (UIButton*)timer.userInfo;
    i--;
    sender.titleLabel.text = [NSString stringWithFormat:@"%d秒倒计时",i];
    [sender setTitle:[NSString stringWithFormat:@"%d秒倒计时",i] forState:UIControlStateNormal];
    if (i==0) {
        [timer invalidate];
        timer = nil;
        sender.enabled = YES;
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (IBAction)confirmAct:(UIButton *)sender {
    if (![self.password.text isEqualToString:self.rePassword.text]) {
        [AlertHelper showAlertWithTitle:@"密码不一致"];
        return;
    }
    [self.view endEditing:YES];
    [[ServiceForUser manager]postMethodName:@"Connect/find_password.html" params:@{@"phone":self.phone.text,@"password":self.password.text,@"captcha":self.code.text,@"client":@"ios"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [AlertHelper showAlertWithTitle:@"修改成功"];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}
@end
