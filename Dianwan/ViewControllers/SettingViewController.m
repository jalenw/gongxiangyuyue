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
#import "BindingPhoneViewController.h"
#import "UserViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableViewCell *userCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *clearCacheCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *pwCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *payPwCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *versionCell;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *versionLb;

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
    
    self.versionLb.text = IosAppVersion;
    
    self.data = @[self.userCell,self.phoneCell,self.pwCell,self.payPwCell,self.clearCacheCell,self.updateCell,self.versionCell];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self updateUI];
}

- (void)updateUI{
    self.phoneLb.text = AppDelegateInstance.defaultUser.phone;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = self.data[indexPath.row];
    CGFloat cellHeight = cell.height;
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.userCell) {
        UserViewController *vc = [[UserViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell == self.clearCacheCell){
        LZHAlertView *alertView = [LZHAlertView createWithTitleArray:@[@"取消",@"确定"]];
        alertView.titleLabel.text = @"提示";
        alertView.contentLabel.text = @"确定清除缓存？";
        __weak SettingViewController *weakSelf = self;
        __weak LZHAlertView *weakAlertView = alertView;
        [alertView setBlock:^(NSInteger index, NSString *title) {
            if (index == 1) {
                [[EMSDImageCache sharedImageCache] clearDisk];
                weakSelf.cacheLabel.text = @"0KB";
            }
            [weakAlertView hide];
        }];
        [alertView show];
    }
    else if (cell==self.updateCell){
    }
    else if (cell==self.phoneCell)
    {
        BindingPhoneViewController *vc = [[BindingPhoneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell==self.pwCell)
    {
        ModifyPwViewController *vc = [[ModifyPwViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (cell==self.payPwCell)
    {
        [SVProgressHUD show];
        [[ServiceForUser manager]postMethodName:@"" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                if ([[data safeDictionaryForKey:@"datas"]safeIntForKey:@"type"]==1) {
                    //若没有设置支付密码，则跳转设置支付密码
                    SetPayPwViewController*vc = [[SetPayPwViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    //若已设置支付密码，则跳转修改支付密码
                    ModifyPwViewController *vc = [[ModifyPwViewController alloc]init];
                    vc.forPayPw = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else [AlertHelper showAlertWithTitle:error];
        }];
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
@end
