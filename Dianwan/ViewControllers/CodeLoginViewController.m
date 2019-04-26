//
//  CodeLoginViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "CodeLoginViewController.h"

@interface CodeLoginViewController ()
{
    int i;
}
@end

@implementation CodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phone.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    self.code.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.code.placeholder attributes:@{NSForegroundColorAttributeName: RGB(196,196,196)}];
    [self setupForDismissKeyboard];
    self.title = @"验证码登录";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAct:(UIButton *)sender {
    [[ServiceForUser manager]postMethodName:@"" params:@{@"phone":self.phone.text,@"type":@"2"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
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
    sender.titleLabel.text = [NSString stringWithFormat:@"%ds后重新获取",i];
    [sender setTitle:[NSString stringWithFormat:@"%ds后重新获取",i] forState:UIControlStateNormal];
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
    [[ServiceForUser manager]postMethodName:@"" params:@{@"phone":self.phone.text,@"captcha":self.code.text,@"client":@"ios"} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [HTTPClientInstance saveToken:[[data safeDictionaryForKey:@"datas"] safeStringForKey:@"key"] uid:[[data safeDictionaryForKey:@"datas"] safeStringForKey:@"member_id"]];
            AppDelegateInstance.defaultUser = [User insertOrReplaceWithDictionary:[data safeDictionaryForKey:@"datas"] context:AppDelegateInstance.managedObjectContext];
            [AppDelegateInstance showMainPage];
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}
@end
