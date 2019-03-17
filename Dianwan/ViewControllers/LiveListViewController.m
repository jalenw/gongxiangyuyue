//
//  LiveListViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "LiveListViewController.h"
#import "LiveListTableViewCell.h"

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
    self.title = @"直播";
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setRightBarButtonWithTitle:@"我要开播"];
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 312;
}

@end
