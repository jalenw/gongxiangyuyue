//
//  AboutHomeViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/17.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AboutHomeViewController.h"
#import "AboutHomeTableViewCell.h"

#import "AboutHomeTableViewCell2.h"

#import "LiveListTableViewCell.h"
@interface AboutHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableview;
@end

@implementation AboutHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requesrLiveListAct];
    self.listTableview.dataSource =self;
    self.listTableview.delegate =self;
    self.listTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTableview registerNib:[UINib nibWithNibName:@"AboutHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"AboutHomeTableViewCell"];
     [self.listTableview registerNib:[UINib nibWithNibName:@"AboutHomeTableViewCell2" bundle:nil] forCellReuseIdentifier:@"AboutHomeTableViewCell2"];
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
}

-(void)requesrLiveListAct{
    NSDictionary *params =@{
                            @"type":@"1",
                            @"page":@(page)
                            };
    [[ServiceForUser manager]postMethodName:@"ordery/order_y_list" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
//    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        
            AboutHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutHomeTableViewCell"];
        //    cell.dict =dataList[indexPath.row];
            return cell;

    }else{
        
        AboutHomeTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutHomeTableViewCell2"];
        //    cell.dict =dataList[indexPath.row];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
          return 211;
    }else{
         return 283;
    }
  
}


@end
