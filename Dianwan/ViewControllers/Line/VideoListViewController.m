//
//  VideoListViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoTableViewCell.h"
@interface VideoListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSMutableArray *dataList;
}
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page =1 ;
    dataList = [[NSMutableArray alloc]init];
    
    [self requesrListAct];

    [self.tableView addLegendFooterWithRefreshingBlock:^{
        page ++;
        [self requesrListAct];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page =1;
        [self requesrListAct];
    }];
}

-(void)requesrListAct{
    NSDictionary *params =@{
                            @"pagesize":@"5",
                            @"page":@(page)
                            };
    [[ServiceForUser manager]postMethodName:@"storevideo/video_list" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (page == 1) {
            [dataList removeAllObjects];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if (status) {
            NSArray *livedata = [data  safeArrayForKey:@"result"];
            [dataList addObjectsFromArray:livedata];
            [self.tableView reloadData];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"VideoTableViewCell" owner:self options:nil][0];
        [cell.bt addTarget:self action:@selector(playAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.bt.tag = indexPath.row;
    if (dataList.count>0) {
        cell.dict =dataList[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict =dataList[indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 238;
}

-(void)playAct:(UIButton*)sender
{
    NSDictionary *dict = dataList[sender.tag];
    MPMoviePlayerViewController *mPMoviePlayerViewController;
    mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[dict safeStringForKey:@"video_url"]]];
    mPMoviePlayerViewController.view.frame = ScreenBounds;
    [self presentViewController:mPMoviePlayerViewController animated:YES completion:nil];
}
@end
