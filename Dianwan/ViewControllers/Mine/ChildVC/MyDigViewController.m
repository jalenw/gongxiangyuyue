//
//  MyDigViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MyDigViewController.h"
#import "MyDigTableViewCell.h"

@interface MyDigViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *mydigTableview;

@end

@implementation MyDigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的矿机";
    dataList = [[NSMutableArray alloc]init];
    page = 1;
    self.mydigTableview.dataSource =self;
    self.mydigTableview.delegate =self;
    self.mydigTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mydigTableview registerNib:[UINib nibWithNibName:@"MyDigTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyDigTableViewCell"];
    [self.mydigTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestMarkdataAct];
    }];
    [self.mydigTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestMarkdataAct];
    }];
}



-(void)requestMarkdataAct{
    NSDictionary *params = @{
                             
                             };
    
    [[ServiceForUser manager] postMethodName:@"" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.mydigTableview.header endRefreshing];
        }else{
            [self.mydigTableview.footer endRefreshing];
        }
        if (status) {
            
        }
        [self.mydigTableview reloadData];
        
    }];
    
}

#pragma mark -代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    //    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDigTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MyDigTableViewCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

@end
