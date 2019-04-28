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
//    [self.classListTableview addLegendFooterWithRefreshingBlock:^{
//        page ++;
//        [self requesrLiveListAct];
//    }];
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
    NSDictionary *params =@{ @"page":@(page)};
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
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        [self.classListTableview reloadData];
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


-(void)cellDownLoadButtonDidClick:(NSDictionary *)dict
{
    if ([dict safeStringForKey:@"courses_video"].length==0) {
        [AlertHelper showAlertWithTitle:@"下载地址无效"];
        return;
    }
    [AlertHelper showAlertWithTitle:@"正在下载"];
    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURL *url = [NSURL URLWithString:[dict safeStringForKey:@"courses_video"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self saveVideoToAlbum:filePath.absoluteString];
        NSLog(@"下载完成");
    }];
    [downloadTask resume];
}

- (void)saveVideoToAlbum:(NSString*)videoPath{
    if(videoPath) {
     BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
        if(compatible){
    UISaveVideoAtPathToSavedPhotosAlbum(videoPath,self,@selector(savedVideoPhotoImage:didFinishSavingWithError:contextInfo:),nil);
        }
    }
}
//保存视频完成之后的回调
- (void)savedVideoPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo: (void*)contextInfo
{
    if(error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else{
        NSLog(@"保存视频成功");
        [AlertHelper showAlertWithTitle:@"下载完成"];
    }
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
