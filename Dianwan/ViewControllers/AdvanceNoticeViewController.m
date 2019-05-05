//
//  AdvanceNoticeViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "AdvanceNoticeViewController.h"
#import "AdvanceNoticeTableViewCell.h"
@interface AdvanceNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@end

@implementation AdvanceNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的预告";
    [self setRightBarButtonWithTitle:@"发布预告"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requestListAct];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdvanceNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvanceNoticeTableViewCell"];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestListAct];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self requestListAct];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"kRefreshAdvanceNoticeList" object:nil];
}

-(void)refresh
{
    page =1;
    [self requestListAct];
}

-(void)requestListAct
{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page),
                            @"my_list":@"1"
                            };
    [[ServiceForUser manager]postMethodName:@"channelforeshow/foreshowList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if (status) {
            NSArray *livedata = [data  safeArrayForKey:@"result"];
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
    AdvanceNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvanceNoticeTableViewCell"];
    cell.dict =dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
