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

@end

@implementation AlreadybuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSDictionary *params =@{
//                            @"pagesize":@"5",
//                            @"page":@(page)
                            };
    [[ServiceForUser manager]postMethodName:@"Channels/getLive" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.classListTableview.header endRefreshing];
        }else{
            [self.classListTableview.footer endRefreshing];
        }
        if (status) {
            NSDictionary *livedata = [data safeDictionaryForKey:@"data"];
            [dataList addObjectsFromArray:[livedata safeArrayForKey:@"result"]];
            [self.classListTableview reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      return 5;
//    return dataList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlertBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertBuyTableViewCell"];
    cell.dict = @{
        @"id": @(1),
        @"order_sn": @"19030810554827723381",
        @"courses_goods_name": @"课程名称",
        @"courses_price": @"200",
        @"courses_goods_image": @"http://shengbafang.oss-cn-shenzhen.aliyuncs.com/mine_machine/oss_uploads/home/common/mine-machine-pic-4.jpg",
        @"courses_skydrive_link": @"http://www.baidu.com",
        @"courses_skydrive_code":@"4",
        @"order_state": @"0",
        @"store_id": @(23),
        @"member_id": @(10381),
        @"pay_time": @"2019-03-08",
        @"courses_goods_id": @(4),
        @"member_name": @"222"
    };//dataList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 452;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//     UIView  *view  =   [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
//    view.backgroundColor = RGB(244, 244, 244);
//    return view;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 53;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 17, 20, 20)];
//    imageView.image = [UIImage imageNamed:@"Group 18"];
//    [view addSubview:imageView];
//
//    UILabel *typelabel =[[UILabel alloc]initWithFrame:CGRectMake(46, 16,ScreenWidth - 80, 21)];
//    typelabel.text = @"游戏";
//    [view addSubview:typelabel];
//    return view;
//}

@end
