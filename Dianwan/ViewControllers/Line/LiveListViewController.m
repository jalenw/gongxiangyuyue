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
#import "WaitPayViewController.h"
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
    
    [self requestLiveListAct];
    self.listTableview.dataSource =self;
    self.listTableview.delegate =self;
    self.listTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTableview registerNib:[UINib nibWithNibName:@"LiveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveListTableViewCell"];
    [self.listTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestLiveListAct];
    }];
    [self.listTableview addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self requestLiveListAct];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"kRefreshLiveList" object:nil];
}

-(void)refresh
{
    page =1;
    [self requestLiveListAct];
}

-(void)requestLiveListAct{
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
