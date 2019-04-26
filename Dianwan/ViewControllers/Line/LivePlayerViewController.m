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
#import "LZHAlertView.h"
@interface LivePlayerViewController ()<IChatManagerDelegate,TXLivePlayListener>
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
        self.msgContentView.width = ScreenWidth-16;
        self.rewardBt.hidden = YES;
        
        //监听是否重新进入程序程序.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        //监听是否触发home键挂起程序.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil]; 
    }
    else
    {
        txLivePlayer = [[TXLivePlayer alloc] init];
        txLivePlayer.delegate = self;
        [txLivePlayer setupVideoWidget:CGRectMake(0, 0, ScreenWidth, ScreenHeight) containView:self.view insertIndex:0];
        [txLivePlayer startPlay:self.url type:PLAY_TYPE_LIVE_RTMP];
        _timeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
        [[ServiceForUser manager] postMethodName:@"channels/enterLiveRoom" params:@{@"room_id":[self.dict safeStringForKey:@"room_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
            }else{
                [AlertHelper showAlertWithTitle:error];
            }
        }];
        self.msgContentView.width = ScreenWidth-62;
        self.rewardBt.hidden = NO;
    }
    msgList = [NSMutableArray new];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncJoinChatroom:[self.dict safeStringForKey:@"chatroom_id"] completion:^(EMChatroom *chatroom, EMError *error) {
        
    }];

    self.bottomView.bottom = ScreenHeight;
}

-(void)applicationDidBecomeActive:(NSNotification *)notification
{
    [txLivePush resumePush];
}

-(void)applicationWillResignActive:(NSNotification *)notification
{
    [txLivePush pausePush];
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
        [self stopRtmpPublish];
        if (_timeTimer) {
            [_timeTimer invalidate];
            _timeTimer = nil;
        }
        [[ServiceForUser manager] postMethodName:@"channels/stopLive" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
            }else{
            }
        }];
    }
    else {
        if (_timeTimer) {
            [_timeTimer invalidate];
            _timeTimer = nil;
        }
        [txLivePlayer stopPlay];
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
    txLivePush = nil;
}

-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    if (EvtID==3005) {
        [AlertHelper showAlertWithTitle:@"直播已停止"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)timeTimerAction:(id)sender
{
    [[ServiceForUser manager] postMethodName:@"Channels/getLiveRoomOnlineNumEarn" params:@{@"room_id":[self.dict safeStringForKey:@"room_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            self.count.text = [NSString stringWithFormat:@"%@人",[[data safeDictionaryForKey:@"result"] safeStringForKey:@"online_num"]];
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
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveMsgTableViewCell" owner:self options:nil][0];
    }
    if (msgList.count>0) {
        EMMessage *message = [msgList objectAtIndex:indexPath.row];
        EMTextMessageBody *body = message.messageBodies.firstObject;
        NSString *text = body.text;
        NSDictionary *dict = [Tooles stringToJson:text];
        cell.contentLb.text = [NSString stringWithFormat:@"%@:%@",[dict safeStringForKey:@"nickName"],[dict safeStringForKey:@"content"]];
        [cell.contentLb sizeToFit];
        if (cell.contentLb.width>=ScreenWidth-32) {
            cell.contentLb.width = ScreenWidth-32;
            cell.contentLb.height = [Tooles calculateTextHeight:ScreenWidth-32 Content:cell.contentLb.text fontSize:16];
        }
        cell.contentBgView.width = cell.contentLb.width + 16;
        cell.contentBgView.height = cell.contentLb.height + 16;
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
    LZHAlertView *alertView = [LZHAlertView createWithTitleArray:@[@"取消",@"确定"]];
    alertView.titleLabel.text = @"提示";
    alertView.contentLabel.text = @"确定退出直播？";
    __weak LZHAlertView *weakAlertView = alertView;
    [alertView setBlock:^(NSInteger index, NSString *title) {
        if (index == 1) {
            [super back];
        }
        [weakAlertView hide];
    }];
    [alertView show];
}

- (IBAction)shareAct:(UIButton *)sender {
}

- (IBAction)sendAct:(UIButton *)sender {
    [self.contentTf resignFirstResponder];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setValue:@(AppDelegateInstance.defaultUser.user_id) forKey:@"userId"];
    [parm setValue:AppDelegateInstance.defaultUser.chat_id forKey:@"chatId"];
    [parm setValue:AppDelegateInstance.defaultUser.nickname forKey:@"nickName"];
    [parm setValue:AppDelegateInstance.defaultUser.avatar forKey:@"avatar"];
    [parm setValue:self.contentTf.text forKey:@"content"];
    [parm setValue:[self.dict safeStringForKey:@"chatroom_id"] forKey:@"room_id"];
    NSMutableDictionary *p = [[NSMutableDictionary alloc]initWithDictionary:@{@"ext":[Tooles jsonToString:parm]}];
    EMMessage *message = [EaseSDKHelper sendTextMessage:[Tooles jsonToString:parm]
                                                     to:[self.dict safeStringForKey:@"chatroom_id"]
                                            messageType:eMessageTypeChatRoom
                                      requireEncryption:NO
                                             messageExt:p];
    
    [msgList addObject:message];
    [self.tableView reloadData];
    [self scrollToBottom];
    self.contentTf.text = @"";
}

- (IBAction)rewardAct:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.rewardTf becomeFirstResponder];
        self.rewardContentView.hidden = NO;
    }
    else
    {
        self.rewardContentView.hidden = YES;
        [SVProgressHUD show];
        [[ServiceForUser manager] postMethodName:@"channels/give_gold" params:@{@"gold":self.rewardTf.text,@"room_id":[self.dict safeStringForKey:@"room_id"]} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                
                NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
                [parm setValue:@(AppDelegateInstance.defaultUser.user_id) forKey:@"userId"];
                [parm setValue:AppDelegateInstance.defaultUser.chat_id forKey:@"chatId"];
                [parm setValue:AppDelegateInstance.defaultUser.nickname forKey:@"nickName"];
                [parm setValue:AppDelegateInstance.defaultUser.avatar forKey:@"avatar"];
                [parm setValue:[NSString stringWithFormat:@"%@赠送了%@金币",AppDelegateInstance.defaultUser.nickname,self.rewardTf.text] forKey:@"content"];
                [parm setValue:[self.dict safeStringForKey:@"chatroom_id"] forKey:@"room_id"];
                NSMutableDictionary *p = [[NSMutableDictionary alloc]initWithDictionary:@{@"ext":[Tooles jsonToString:parm]}];
                EMMessage *message = [EaseSDKHelper sendTextMessage:[Tooles jsonToString:parm]
                                                                 to:[self.dict safeStringForKey:@"chatroom_id"]
                                                        messageType:eMessageTypeChatRoom
                                                  requireEncryption:NO
                                                         messageExt:p];
                
                [msgList addObject:message];
                [self.tableView reloadData];
                [self scrollToBottom];
                
                [self.rewardTf resignFirstResponder];
                self.rewardTf.text = @"";
            }else{
                [AlertHelper showAlertWithTitle:error];
            }
        }];
    }
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[msgList count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
