//
//  SettingViewController.m
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SettingViewController.h"
#import "LZHAlertView.h"
#import "CommonUIWebViewController.h"
#import "ModifyPwViewController.h"
#import "SetPayPwViewController.h"
#import "SetPayPwViewController.h"
#import "UserViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableViewCell *feedbackCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *privacyPolicyCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearCacheCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pwCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *payPwCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutUsCell;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (nonatomic, strong) NSArray *data;

@end

@implementation SettingViewController


- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.data = @[@[self.pwCell,self.payPwCell,self.clearCacheCell],@[self.feedbackCell,self.aboutUsCell,self.privacyPolicyCell]];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self updateUI];
}

- (void)updateUI{
    [[EMSDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        if (totalSize > 1024 * 1024)
        {
            self.cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", totalSize / 1024.0 / 1024];
        }
        else
        {
            self.cacheLabel.text = [NSString stringWithFormat:@"%.1fKB", totalSize / 1024.0];
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *countArr =self.data[section];
    return countArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = self.data[indexPath.section][indexPath.row];
    CGFloat cellHeight = cell.height;
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = self.data[indexPath.section][indexPath.row];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == self.privacyPolicyCell) {
            CommonUIWebViewController * privacyPolicy = [[CommonUIWebViewController alloc] init];
            privacyPolicy.address = [NSString stringWithFormat:@"%@wap/mall/info.html?article_id=59",web_url];
            privacyPolicy.showNav = NO;
            [self.navigationController pushViewController:privacyPolicy animated:YES];
        }else if (cell == self.aboutUsCell)
        {
            CommonUIWebViewController * privacyPolicy = [[CommonUIWebViewController alloc] init];
            privacyPolicy.address = [NSString stringWithFormat:@"%@wap/mall/info.html?article_id=58",web_url];
            privacyPolicy.showNav = NO;
            [self.navigationController pushViewController:privacyPolicy animated:YES];
        }
        else if (cell == self.clearCacheCell){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理缓存"
                                                                           message:[NSString stringWithFormat:@"确认清理%@缓存",self.clearCacheCell.textLabel.text]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                     NSLog(@"取消按钮被按下！");
                                                                 }];
            [alert addAction:cancelAction];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      [self clearBtnAction];
                                                                  }];
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
    }
    else if (cell==self.feedbackCell){
        CommonUIWebViewController * privacyPolicy = [[CommonUIWebViewController alloc] init];
        privacyPolicy.address = [NSString stringWithFormat:@"%@wap/member/member_feedback.html?",web_url];
        privacyPolicy.showNav = NO;
        [self.navigationController pushViewController:privacyPolicy animated:YES];
    }
    else if (cell==self.pwCell)
    {
  
        ModifyPwViewController *vc = [[ModifyPwViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell==self.payPwCell)
    {
        SetPayPwViewController *setpay = [[SetPayPwViewController alloc]init];
        [self.navigationController pushViewController:setpay animated:YES];
//        [SVProgressHUD show];
//        [[ServiceForUser manager]postMethodName:@"" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
//            [SVProgressHUD dismiss];
//            if (status) {
//                if ([[data safeDictionaryForKey:@"datas"]safeIntForKey:@"type"]==1) {
//                    //若没有设置支付密码，则跳转设置支付密码
//                    SetPayPwViewController*vc = [[SetPayPwViewController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                else
//                {
//                    //若已设置支付密码，则跳转修改支付密码
//                    ModifyPwViewController *vc = [[ModifyPwViewController alloc]init];
//                    vc.forPayPw = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            }
//            else [AlertHelper showAlertWithTitle:error];
//        }];
    }
}

- (IBAction)logoutAct:(UIButton *)sender {
    LZHAlertView *alertView = [LZHAlertView createWithTitleArray:@[@"取消",@"确定"]];
    alertView.titleLabel.text = @"提示";
    alertView.contentLabel.text = @"确定退出登录？";
    __weak LZHAlertView *weakAlertView = alertView;
    [alertView setBlock:^(NSInteger index, NSString *title) {
        if (index == 1) {
            [AppDelegateInstance logout];
        }
        [weakAlertView hide];
    }];
    [alertView show];
}


- (void)clearBtnAction {
    [[EMSDImageCache sharedImageCache] clearDisk];
    self.cacheLabel.text = @"0KB";
}




@end
