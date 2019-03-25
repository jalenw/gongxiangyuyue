//
//  AlreadybuyViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AlreadybuyViewController.h"
#import "AlertBuyTableViewCell.h"

@interface AlreadybuyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *classListTableview;
@property(nonatomic,strong)NSString *oss_url;
@end

@implementation AlreadybuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已购课程";
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requesrLiveListAct];
    self.classListTableview.dataSource =self;
    self.classListTableview.delegate =self;
    self.classListTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.classListTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.classListTableview registerNib:[UINib nibWithNibName:@"AlertBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlertBuyTableViewCell"];
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
    NSDictionary *params =@{};
    [[ServiceForUser manager]postMethodName:@"coursesgoods/myPurchasedCourses" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.classListTableview.header endRefreshing];
        }else{
            [self.classListTableview.footer endRefreshing];
        }
        if (status) {
            self.oss_url =[data safeStringForKey:@"oss_url"];
            [dataList addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.classListTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlertBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertBuyTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ossurl =self.oss_url;
    cell.dict =dataList[indexPath.row];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 452;
}


@end
