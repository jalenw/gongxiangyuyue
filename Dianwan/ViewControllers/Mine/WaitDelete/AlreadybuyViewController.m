//
//  AlreadybuyViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AlreadybuyViewController.h"
#import "AlertBuyTableViewCell.h"
#import "JPVideoPlayerKit.h"

@interface AlreadybuyViewController ()<UITableViewDelegate,UITableViewDataSource,JPScrollViewPlayVideoDelegate,JPVPNetEasyTableViewCellDelegate>
{
    int page;
    NSMutableArray *dataList;
    
}
@property (weak, nonatomic) IBOutlet UITableView *classListTableview;
@property(nonatomic,strong)NSString *oss_url;

@property (nonatomic, strong) AlertBuyTableViewCell *playingCell;
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
    self.classListTableview.jp_delegate = self;
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.playingCell) {
        [self.playingCell.coverImageView jp_stopPlay];
    }
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
    cell.delegate = self;
    cell.playBtn.hidden = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 452;
}




- (void)cellPlayButtonDidClick:(AlertBuyTableViewCell *)cell {
    if (self.playingCell) {
        [self.playingCell.coverImageView jp_stopPlay];
        self.playingCell.playBtn.hidden = NO;
    }
    self.playingCell = cell;
    self.playingCell.playBtn.hidden = YES;
    self.playingCell.coverImageView.jp_videoPlayerDelegate = self;
    NSIndexPath *indexPath = [self.classListTableview indexPathForCell:cell];
    [self.playingCell.coverImageView jp_playVideoWithURL:[NSURL URLWithString:[dataList[indexPath.row] safeStringForKey:@"courses_video"]]
                                     bufferingIndicator:[JPVideoPlayerBufferingIndicator new]
                                            controlView:[[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil]
                                           progressView:nil
                                          configuration:nil];
}


#pragma mark - TableViewDelegate


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.playingCell) {
        return;
    }
    if (cell.hash == self.playingCell.hash) {
        [self.playingCell.coverImageView jp_stopPlay];
        self.playingCell.playBtn.hidden = NO;
        self.playingCell = nil;
    }
}

#pragma mark - JPVideoPlayerDelegate

- (BOOL)shouldShowBlackBackgroundWhenPlaybackStart {
    return YES;
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}

- (BOOL)shouldAutoHideControlContainerViewWhenUserTapping {
    return YES;
}

- (BOOL)shouldShowDefaultControlAndIndicatorViews {
    return NO;
}



@end
