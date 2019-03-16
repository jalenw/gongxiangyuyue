//
//  AlreadybuyViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AlreadybuyViewController.h"
#import "ClassListTableViewCell.h"

@interface AlreadybuyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *classListTableview;

@end

@implementation AlreadybuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requesrLiveListAct];
    self.classListTableview.dataSource =self;
    self.classListTableview.delegate =self;
    self.classListTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.classListTableview registerNib:[UINib nibWithNibName:@"ClassListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassListTableViewCell"];
    [self.classListTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requesrLiveListAct];
    }];
    [self.classListTableview addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self requesrLiveListAct];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


-(void)requesrLiveListAct{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page)
                            };
    [[ServiceForUser manager]postMethodName:@"Channels/getLive" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.classListTableview.header endRefreshing];
        }else{
            [self.classListTableview.footer endRefreshing];
        }
        if (status) {
            NSArray *livedata = [data safeArrayForKey:@"data"];
            [dataList addObjectsFromArray:livedata];
            [self.classListTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassListTableViewCell"];
    cell.dict =dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
