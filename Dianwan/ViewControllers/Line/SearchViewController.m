//
//  SearchViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/7.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "SearchViewController.h"
#import "LiveListTableViewCell.h"
#import "LivePlayerViewController.h"
#import "WaitPayViewController.h"
#import "PaySucessViewController.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchView;
    [self setupForDismissKeyboard];
    page = 1;
    dataList = [[NSMutableArray alloc]init];

    [self.listTableview registerNib:[UINib nibWithNibName:@"LiveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTableViewCell"];
    [self.listTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestLiveListAct];
    }];
    [self.listTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestLiveListAct];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"kRefreshLiveList" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarButtonWithTitle:@"搜索"];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    [self refresh];
}

-(void)refresh
{
    page = 1;
    [self requestLiveListAct];
}

-(void)requestLiveListAct{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page),
                            @"title":self.content.text
                            };
    [[ServiceForUser manager]postMethodName:@"Channels/search" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.listTableview.header endRefreshing];
        }else{
            [self.listTableview.footer endRefreshing];
        }
        if (status) {
            if ([[data  safeDictionaryForKey:@"result"] safeIntForKey:@"total"]==0) {
                [AlertHelper showAlertWithTitle:@"暂无搜索结果"];
                return;
            }
            NSArray *livedata = [[data  safeDictionaryForKey:@"result"] safeArrayForKey:@"data"];
            [dataList addObjectsFromArray:livedata];
            [self.listTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveListTableViewCell"];
    cell.dict =dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict =dataList[indexPath.row];
    if ([dict safeBoolForkey:@"is_buy"]||[dict safeIntForKey:@"channel_type"]==1) {
        LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
        vc.url = [dict safeStringForKey:@"play"];
        vc.dict = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        WaitPayViewController *waitpay = [[WaitPayViewController alloc]init];
        [waitpay setBlock:^(NSDictionary * _Nonnull dict) {
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            paysuc.btText = @"查看购买直播";
            [paysuc setBlock:^{
                LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
                vc.url = [dict safeStringForKey:@"play"];
                vc.dict = dict;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:paysuc animated:YES];
        }];
        waitpay.dict = dict;
        waitpay.type = 4;
        waitpay.moneryNum =[dict safeStringForKey:@"channel_price"];
        waitpay.order_id = [dict safeStringForKey:@"chatroom_id"];
        [self.navigationController pushViewController:waitpay animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 312;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
