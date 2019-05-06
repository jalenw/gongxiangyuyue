//
//  MineHistoryViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MineHistoryViewController.h"
#import "DigTableViewCell.h"
#import "MillDetailsViewController.h"
#import "WaitPayViewController.h"

@interface MineHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@end

@implementation MineHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataList = [[NSMutableArray alloc]init];
    page = 1;
    
    [self.digTableview registerNib:[UINib nibWithNibName:@"DigTableViewCell" bundle:nil] forCellReuseIdentifier:@"DigTableViewCell"];
    [self.digTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestMarkdataAct];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMarkdataAct];
}

-(void)requestMarkdataAct{
    NSDictionary *params = @{ @"page":@(page)};
    [[ServiceForUser manager] postMethodName:@"minemachine/lis_mineMachineList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.digTableview.header endRefreshing];
        }
        if (status) {
            [dataList removeAllObjects];
            [dataList addObjectsFromArray:[[data safeDictionaryForKey:@"result"] safeArrayForKey:@"mine_machine_list"]];
            [self.digTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
}

#pragma mark -代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DigTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"DigTableViewCell"];
    cell.dict = dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *params =@{
                            @"mine_machine_id":@([dataList[indexPath.row] safeIntForKey:@"id"])
                            };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"minemachine/mineMachineCreatePay" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            WaitPayViewController *wait = [[WaitPayViewController alloc]init];
            wait.type = 1;
            wait.moneryNum =[NSString stringWithFormat:@"%d", [dataList[indexPath.row] safeIntForKey:@"mine_machine_price"]];
            wait.order_id =[[data safeDictionaryForKey:@"result"] safeStringForKey:@"order_id"];
            [self.navigationController pushViewController:wait animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
}

@end
