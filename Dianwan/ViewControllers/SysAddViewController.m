//
//  SystemMsgViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/31.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "SysAddViewController.h"
#import "SystemMsgTableViewCell.h"

@interface SysAddViewController ()
{
    NSMutableArray *array;
}
@end

@implementation SysAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    array = [[NSMutableArray alloc]init];
    [self refresh];
}

-(void)refresh
{
//    [array removeAllObjects];
//    [[ServiceForUser manager]postMethodName:@"friend/apply_for_list" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
//        if (status) {
//            [array addObjectsFromArray:[data safeArrayForKey:@"result"]];
//            [self.tableView reloadData];
//        }
//    }];
    
    [[ServiceForUser manager]postMethodName:@"friend/apply_for_list1" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [array addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMsgTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SystemMsgTableViewCell" owner:self options:nil][0];
        [cell.bt addTarget:self action:@selector(agreenAct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bt2 addTarget:self action:@selector(rejectAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    cell.bt.tag = indexPath.row;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    cell.name.text = [dict safeStringForKey:@"member_name"];
    if([[dict safeStringForKey:@"receive"]isEqualToString:AppDelegateInstance.defaultUser.chat_id])
    {
        if ([dict safeIntForKey:@"status"]==0) {
            cell.bt.hidden = NO;
            cell.bt2.hidden = NO;
            cell.content.text = @"";
        }
        if ([dict safeIntForKey:@"status"]==1) {
            cell.content.text = @"已同意";
            cell.bt.hidden = YES;
            cell.bt2.hidden = YES;
        }
        if ([dict safeIntForKey:@"status"]==2) {
            cell.content.text = @"已拒绝";
            cell.bt.hidden = YES;
            cell.bt2.hidden = YES;
        }
    }
    else
    {
        cell.bt.hidden = YES;
        cell.bt2.hidden = YES;
        if ([dict safeIntForKey:@"status"]==0) {
            cell.content.text = @"待审核";
        }
        if ([dict safeIntForKey:@"status"]==1) {
            cell.content.text = @"已同意";
        }
        if ([dict safeIntForKey:@"status"]==2) {
            cell.content.text = @"已拒绝";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)agreenAct:(UIButton*)sender
{
    NSDictionary *dict = [array objectAtIndex:sender.tag];
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"friend/apply_for_status" params:@{@"status":@"1",@"id":[dict safeStringForKey:@"id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [self refresh];
        }
        else
        {
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)rejectAct:(UIButton*)sender
{
    NSDictionary *dict = [array objectAtIndex:sender.tag];
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"friend/apply_for_status" params:@{@"status":@"2",@"id":[dict safeStringForKey:@"id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [self refresh];
        }
        else
        {
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
