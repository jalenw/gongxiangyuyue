//
//  MyViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "MyViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"
#import "UserViewController.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (AppDelegateInstance.defaultUser!=nil) {
        [self.pic sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
        self.name.text = AppDelegateInstance.defaultUser.nickname;
    }
    else
    {
        self.name.text = @"请登录";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAct:(UIButton *)sender {
    if (AppDelegateInstance.defaultUser==nil) {
        [AppDelegateInstance showLoginView];
    }
    else
    {
        UserViewController *vc = [[UserViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)menuAct:(UIButton *)sender {
    if (sender.tag==0) {//用户订单
        
    }
    if (sender.tag==1) {//用户反馈
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==2) {//邀请好友
        
    }
    if (sender.tag==3) {//关于我们
        
    }
    if (sender.tag==4) {//用户设置
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
