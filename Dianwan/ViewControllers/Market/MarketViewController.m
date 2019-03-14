//
//  MarketViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/12.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketTableViewCell.h"

@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *marketTableview;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"市场";
    dataList = [[NSMutableArray alloc]init];
    page = 1;
    self.marketTableview.dataSource =self;
    self.marketTableview.delegate =self;
    self.marketTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.marketTableview registerNib:[UINib nibWithNibName:@"MarketTableViewCell" bundle:nil] forCellReuseIdentifier:@"MarketTableViewCell"];
    [self.marketTableview addLegendFooterWithRefreshingBlock:^{
         page ++;
          [self requestMarkdataAct];
    }];
    [self.marketTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestMarkdataAct];
    }];
}

-(void)requestMarkdataAct{
    NSDictionary *params = @{
                             
                             };
    
    [[ServiceForUser manager] postMethodName:@"" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.marketTableview.header endRefreshing];
        }else{
            [self.marketTableview.footer endRefreshing];
        }
        if (status) {
            
        }
        [self.marketTableview reloadData];
        
    }];
    
}

#pragma mark -代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
//    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MarketTableViewCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}

@end
