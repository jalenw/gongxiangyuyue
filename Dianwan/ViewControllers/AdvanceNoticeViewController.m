//
//  AdvanceNoticeViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "AdvanceNoticeViewController.h"
#import "AdvanceNoticeTableViewCell.h"
#import "PostAdvanceNoticeViewController.h"
#import "PreviewDetailViewController.h"
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

    page =0 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requestListAct];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdvanceNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvanceNoticeTableViewCell"];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestListAct];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page =0;
        [self requestListAct];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"kRefreshAdvanceNoticeList" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)rightbarButtonDidTap:(UIButton*)button{
    PostAdvanceNoticeViewController *vc = [[PostAdvanceNoticeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refresh
{
    page =0;
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
    AdvanceNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvanceNoticeTableViewCell"];
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
    return 97;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
     NSDictionary *dict =dataList[indexPath.row];
      NSDictionary *params =@{
                              @"id":[dict safeStringForKey:@"id"]
                              };
      [[ServiceForUser manager]postMethodName:@"channelforeshow/delForeshow" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
          if (status) {
              [dataList removeObjectAtIndex:indexPath.row];
              [self.tableView reloadData];
          }else{
              [AlertHelper showAlertWithTitle:error];
          }
      }];
  }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
