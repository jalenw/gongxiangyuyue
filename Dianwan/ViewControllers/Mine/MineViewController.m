//
//  MineViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/12.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MineViewController.h"
#import "DigTableViewCell.h"
#import "MyDigViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataList;
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *digTableview;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挖矿";
    [self setRightBarButtonWithTitle:@"我的矿机"];
    dataList = [[NSMutableArray alloc]init];
    page = 1;
    self.digTableview.dataSource =self;
    self.digTableview.delegate =self;
    self.digTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.digTableview registerNib:[UINib nibWithNibName:@"DigTableViewCell" bundle:nil] forCellReuseIdentifier:@"DigTableViewCell"];
    [self.digTableview addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requestMarkdataAct];
    }];
    [self.digTableview addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [self requestMarkdataAct];
    }];
}


-(void)rightbarButtonDidTap:(UIButton *)button{
    MyDigViewController *mydig = [[MyDigViewController alloc]init];
    [self.navigationController pushViewController:mydig animated:YES];
}

-(void)requestMarkdataAct{
    NSDictionary *params = @{
                             
                             };
    
    [[ServiceForUser manager] postMethodName:@"" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.digTableview.header endRefreshing];
        }else{
            [self.digTableview.footer endRefreshing];
        }
        if (status) {
            
        }
        [self.digTableview reloadData];
        
    }];
    
}

#pragma mark -代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    //    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DigTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"DigTableViewCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
}
@end
