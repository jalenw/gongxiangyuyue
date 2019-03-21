//
//  LivePlayerViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "TXLiteAVSDK_Professional/TXLiveBase.h"
#import "LiveMsgTableViewCell.h"
@interface LivePlayerViewController ()<IChatManagerDelegate>
{
    TXLivePlayer *txLivePlayer;
    TXLivePush *txLivePush;
    NSMutableArray *msgList;
    NSTimer *_timeTimer;
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
        _timeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
        [self.img sd_setImageWithURL:[NSURL URLWithString:[self.dict safeStringForKey:@"member_avatar"]]];
        self.name.text = [[self.dict safeDictionaryForKey:@"msg"]safeStringForKey:@"title"];
    }
    else
    {
        txLivePlayer = [[TXLivePlayer alloc] init];
        [txLivePlayer setupVideoWidget:CGRectMake(0, 0, ScreenWidth, ScreenHeight) containView:self.view insertIndex:0];
        [txLivePlayer startPlay:self.url type:PLAY_TYPE_LIVE_RTMP];
        
        [[ServiceForUser manager] postMethodName:@"channels/enterLiveRoom" params:@{@"room_id":[self.dict safeStringForKey:@"room_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
            }else{
                [AlertHelper showAlertWithTitle:error];
            }
        }];
    }
    msgList = [NSMutableArray new];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncJoinChatroom:[self.dict safeStringForKey:@"chatroom_id"] completion:^(EMChatroom *chatroom, EMError *error) {
        
    }];
    
    self.bottomView.bottom = ScreenHeight;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.forPush) {
        if (_timeTimer) {
            [_timeTimer invalidate];
            _timeTimer = nil;
        }
        [self stopRtmpPublish];
        [[ServiceForUser manager] postMethodName:@"channels/stopLive" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
            }else{
            }
        }];
    }
    else {
        [[ServiceForUser manager] postMethodName:@"channels/exitLiveRoom" params:@{@"room_id":[self.dict safeStringForKey:@"room_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
            }else{
            }
        }];
    }
    [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:[self.dict safeStringForKey:@"chatroom_id"] completion:^(EMChatroom *chatroom, EMError *error) {
    }];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)stopRtmpPublish {
    [txLivePush stopPreview];
    [txLivePush stopPush];
    txLivePush.delegate = nil;
}

- (void)timeTimerAction:(id)sender
{
    [[ServiceForUser manager] postMethodName:@"channels/get_video_match" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
        }else{
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (msgList.count>0) {
        EMMessage *message = [msgList objectAtIndex:indexPath.row];
        return [LiveMsgTableViewCell heightForLiveMsgTableViewCell:message];
    }
    else
        return 49;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveMsgTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"FriendListCell" owner:self options:nil][0];
    }
    if (msgList.count>0) {
        EMMessage *message = [msgList objectAtIndex:indexPath.row];
    
    }
    return cell;
}

-(void)didReceiveMessage:(EMMessage *)message
{
    [msgList addObject:message];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username
{
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username
{
}

- (IBAction)closeAct:(UIButton *)sender {
    [super back];
}

- (IBAction)shareAct:(UIButton *)sender {
}

- (IBAction)sendAct:(UIButton *)sender {
}

-(void)inputKeyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomView.bottom = keyboardRect.origin.y;
}

-(void)inputKeyboardWillHide:(NSNotification*)notification
{
    self.bottomView.bottom = ScreenHeight;
}

- (void)scrollToBottom
{
    CGFloat yOffset = CGFLOAT_MAX;
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
