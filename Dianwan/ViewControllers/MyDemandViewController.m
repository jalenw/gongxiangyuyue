//
//  MyDemandViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MyDemandViewController.h"
#import "MyDemandTableViewCell.h"
@interface MyDemandViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}

@end

@implementation MyDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的需求";
    [self setRightBarButtonWithTitle:@"发布需求"];
    
    page =0 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDemandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyDemandTableViewCell"];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestListAct];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page =0;
        [self requestListAct];
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView headerBeginRefreshing];
}

-(void)rightbarButtonDidTap:(UIButton*)button{
    CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
    controller.address = [NSString stringWithFormat:@"%@dist/appointment/releaseDemand",web_url];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)requestListAct
{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page),
                            @"my_list":@"1"
                            };
    [[ServiceForUser manager]postMethodName:@"appointdemand/myDemand" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 0) {
            [dataList removeAllObjects];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if (status) {
            NSArray *livedata = [data safeArrayForKey:@"result"];
            [dataList addObjectsFromArray:livedata];
            [self.tableView reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDemandTableViewCell"];
    cell.dict =dataList[indexPath.row];
    cell.bt.tag = indexPath.row;
    [cell.bt addTarget:self action:@selector(deleteAct:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 141;
}

-(void)deleteAct:(UIButton*)sender
{
    NSDictionary *dict = dataList[sender.tag];
    [SVProgressHUD show];
    NSDictionary *params =@{
                            @"id":[dict safeStringForKey:@"id"]
                            };
    [[ServiceForUser manager]postMethodName:@"Appointdemand/delDemand" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
            [dataList removeObjectAtIndex:sender.tag];
            [self.tableView reloadData];
    }];
}
@end
