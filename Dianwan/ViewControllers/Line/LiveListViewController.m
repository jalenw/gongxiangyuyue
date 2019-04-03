//
//  LiveListViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "LiveListViewController.h"
#import "LiveListTableViewCell.h"
#import "LivePlayerViewController.h"
#import "LZHAlertView.h"
@interface LiveListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableview;

@end

@implementation LiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requesrLiveListAct];
    self.listTableview.dataSource =self;
    self.listTableview.delegate =self;
    self.listTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTableview registerNib:[UINib nibWithNibName:@"LiveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTableViewCell"];
    [self.listTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requesrLiveListAct];
    }];
    [self.listTableview addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self requesrLiveListAct];
    }];
    
}

-(void)requesrLiveListAct{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page)
                            };
    [[ServiceForUser manager]postMethodName:@"Channels/getLive" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.listTableview.header endRefreshing];
        }else{
            [self.listTableview.footer endRefreshing];
        }
        if (status) {
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
    NSDictionary *dict =dataList[indexPath.row];
    
    
    LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
    vc.url = [dict safeStringForKey:@"play"];
    vc.dict = dict;
    [self.navigationController pushViewController:vc animated:YES];
    
//    LZHAlertView *alertView = [LZHAlertView createWithTitleArray:@[@"取消",@"确定支付"]];
//    alertView.titleLabel.text = @"付费直播";
//    alertView.contentLabel.text = @"";
//    __weak LZHAlertView *weakAlertView = alertView;
//    [alertView setBlock:^(NSInteger index, NSString *title) {
//        if (index == 1) {
//           
//        }
//        [weakAlertView hide];
//    }];
//    [alertView show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 312;
}

@end
