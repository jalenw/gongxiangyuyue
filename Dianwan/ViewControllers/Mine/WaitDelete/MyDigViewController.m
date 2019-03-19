//
//  MyDigViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MyDigViewController.h"
#import "MyDigTableViewCell.h"
#import "MillDetailsViewController.h"

@interface MyDigViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *mydigTableview;

@end

@implementation MyDigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的矿机";
    dataList = [[NSMutableArray alloc]init];
    page = 1;
    [self requestMarkdataAct];
    self.mydigTableview.dataSource =self;
    self.mydigTableview.delegate =self;
    self.mydigTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mydigTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mydigTableview registerNib:[UINib nibWithNibName:@"MyDigTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyDigTableViewCell"];
    [self.mydigTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestMarkdataAct];
    }];
}



-(void)requestMarkdataAct{
    NSDictionary *params = @{};
    
    [[ServiceForUser manager] postMethodName:@"minemachine/myMineMachineList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.mydigTableview.header endRefreshing];
        }
        if (status) {
            [dataList removeAllObjects];
            [dataList addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.mydigTableview reloadData];
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
    MyDigTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MyDigTableViewCell"];
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
            //进入矿机详情页
            MillDetailsViewController *milldetails = [[MillDetailsViewController alloc]init];
            milldetails.order_id = [[data safeDictionaryForKey:@"result"] safeStringForKey:@"order_id"];
            [self.navigationController pushViewController:milldetails animated:YES];
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

@end
