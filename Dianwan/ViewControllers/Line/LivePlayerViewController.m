//
//  LivePlayerViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "TXLiteAVSDK_Professional/TXLiveBase.h"
@interface LivePlayerViewController ()
{
    TXLivePlayer *txLivePlayer;
    TXLivePush *txLivePush;
}
@end

@implementation LivePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    if (self.forPush) {
        TXLivePushConfig* _config = [[TXLivePushConfig alloc] init];
        txLivePush = [[TXLivePush alloc] initWithConfig: _config];
        [txLivePush startPreview:self.view];
        [txLivePush startPush:self.url];
    }
    else
    {
        txLivePlayer = [[TXLivePlayer alloc] init];
        [txLivePlayer setupVideoWidget:CGRectMake(0, 0, ScreenWidth, ScreenHeight) containView:self.view insertIndex:0];
        [txLivePlayer startPlay:self.url type:PLAY_TYPE_LIVE_RTMP];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.forPush) {
        [self stopRtmpPublish];
    }
}

- (void)stopRtmpPublish {
    [txLivePush stopPreview];
    [txLivePush stopPush];
    txLivePush.delegate = nil;
}
- (IBAction)closeAct:(UIButton *)sender {
    [super back];
}

- (IBAction)shareAct:(UIButton *)sender {
}

- (IBAction)sendAct:(UIButton *)sender {
}
@end
