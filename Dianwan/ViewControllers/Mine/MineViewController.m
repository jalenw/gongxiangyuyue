//
//  MineViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/12.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MineViewController.h"
#import "DigTableViewCell.h"
#import "MyDigViewController.h"
#import "MillDetailsViewController.h"
#import "WaitPayViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *digTableview;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挖矿";
    [self setRightBarButtonWithTitle:@"我的矿机"];
    dataList = [[NSMutableArray alloc]init];
    page = 1;
   
    self.digTableview.dataSource =self;
    self.digTableview.delegate =self;
    self.digTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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

//重写右按钮
- (UIButton*)setRightBarButtonWithTitle:(NSString*)title{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightbarButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = DefaultFontOfSize(15);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem sx_setRightBarButtonItems:@[rightBarItem]];
    return button;
}


-(void)rightbarButtonDidTap:(UIButton *)button{
//    MillDetailsViewController *mydig=[[MillDetailsViewController alloc]init];
//    MyDigViewController *mydig = [[MyDigViewController alloc]init];
//    [self.navigationController pushViewController:mydig animated:YES];
   if (![HTTPClientInstance isLogin]) {
        [AppDelegateInstance showLoginView];
    }
    else
    {
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/dig/mill",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    
}

-(void)requestMarkdataAct{
    NSDictionary *params = @{};
    [[ServiceForUser manager] postMethodName:@"minemachine/mineMachineList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.digTableview.header endRefreshing];
        }
        if (status) {
            [dataList removeAllObjects];
            [dataList addObjectsFromArray:[[data safeDictionaryForKey:@"result"] safeArrayForKey:@"mine_machine_list"]];
             [self setRightBarButtonWithTitle:[NSString stringWithFormat:@"我的矿机(%d)",[[data safeDictionaryForKey:@"result"] safeIntForKey:@"num"]]];
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
