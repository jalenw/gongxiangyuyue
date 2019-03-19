//
//  MarketViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/12.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketTableViewCell.h"
#import "ReleaseAdvViewController.h"
#import "AdvDetailsViewController.h"

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
    [self setRightBarButtonWithTitle:@"发布广告"];
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
        [dataList removeAllObjects];
        [self requestMarkdataAct];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self requestMarkdataAct];
}

//重写右按钮
- (UIButton*)setRightBarButtonWithTitle:(NSString*)title{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(rightbarButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = DefaultFontOfSize(15);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem sx_setRightBarButtonItems:@[rightBarItem]];
    return button;
}


-(void)rightbarButtonDidTap:(UIButton *)button{
    ReleaseAdvViewController *mydig = [[ReleaseAdvViewController alloc]init];
    [self.navigationController pushViewController:mydig animated:YES];
}


-(void)requestMarkdataAct{
    NSDictionary *params = @{
                             @"page":@(page)
                             };
    
    [[ServiceForUser manager] postMethodName:@"/mobile/advertising/advlist" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [self.marketTableview.header endRefreshing];
        }else{
            [self.marketTableview.footer endRefreshing];
        }
        if (status) {
          [dataList addObjectsFromArray:[data safeArrayForKey:@"result"]];
            [self.marketTableview reloadData];
        }else
        {
            [AlertHelper showAlertWithTitle:error];
        }
        [self.marketTableview reloadData];
    }];
    
}

#pragma mark -代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MarketTableViewCell"];
    cell.dict= dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdvDetailsViewController *advdetail = [[AdvDetailsViewController alloc]init];
    advdetail.adv_id =[dataList[indexPath.row] safeIntForKey:@"id"];
    [self.navigationController pushViewController:advdetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}

@end
