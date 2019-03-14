//
//  FeedbackViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setupForDismissKeyboard];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAct:(UIButton *)sender {
    [[ServiceForUser manager]postMethodName:@"/wap/member/member_feedback.html" params:@{@"content":self.textView.text} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [AlertHelper showAlertWithTitle:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [AlertHelper showAlertWithTitle:error];
    }];
}
@end
