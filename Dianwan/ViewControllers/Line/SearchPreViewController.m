//
//  SearchPreViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "SearchPreViewController.h"
#import "PreviewTableViewCell.h"
#import "PreviewDetailViewController.h"
@interface SearchPreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@end

@implementation SearchPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page =0 ;
    dataList = [[NSMutableArray alloc]init];
    self.navigationItem.titleView = self.searchView;
    [self setupForDismissKeyboard];
    [self requestLiveListAct];
    [self.listTableview registerNib:[UINib nibWithNibName:@"PreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"PreviewTableViewCell"];
    [self.listTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestLiveListAct];
    }];
    [self.listTableview addLegendHeaderWithRefreshingBlock:^{
        page =0;
        [self requestLiveListAct];
    }];
}

-(void)requestLiveListAct{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page),
                            @"my_list":@"0",
                            @"search":self.content.text
                            };
    [[ServiceForUser manager]postMethodName:@"channelforeshow/foreshowList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 0) {
            [dataList removeAllObjects];
            [self.listTableview.header endRefreshing];
        }else{
            [self.listTableview.footer endRefreshing];
        }
        if (status) {
            NSArray *livedata = [data  safeArrayForKey:@"result"];
            [dataList addObjectsFromArray:livedata];
            [self.listTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButtonWithTitle:@"搜索"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreviewTableViewCell"];
    cell.dict =dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PreviewDetailViewController *vc = [[PreviewDetailViewController alloc]init];
    vc.dict = dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 201;
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    [self refresh];
}

-(void)refresh
{
    page =0;
    [self requestLiveListAct];
}
@end
