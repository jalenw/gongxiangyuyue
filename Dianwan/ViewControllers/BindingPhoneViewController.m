//
//  BindingPhoneViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/5.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BindingPhoneViewController.h"

@interface BindingPhoneViewController ()
{
    int i;
}
@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换手机";
    [self setupForDismissKeyboard];
    self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phone.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    self.code.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.code.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)getCodeAct:(UIButton *)sender {
    [[ServiceForUser manager]postMethodName:@"" params:@{@"phone":self.phone.text,@"type":@"4"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
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
    [self.view endEditing:YES];
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"" params:@{@"phone":self.phone.text,@"captcha":self.code.text,@"type":@"4"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            AppDelegateInstance.defaultUser.phone = self.phone.text;
            [AppDelegateInstance saveContext];
            [AlertHelper showAlertWithTitle:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
