//
//  ClassDetailViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/24.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "ClassDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WaitPayViewController.h"
#import "JPVideoPlayerKit.h"
#import "ChatViewController.h"
@interface ClassDetailViewController ()<JPVideoPlayerControlViewDelegate>
{
    NSDictionary *dict;
    NSTimer *timer;
}
@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";
    
    [[ServiceForUser manager] postMethodName:@"coursesgoods/coursesGoodsDetail" params:@{@"courses_goods_id":self.classId} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            dict = [data safeDictionaryForKey:@"result"];
            self.nameLb.text = [dict safeStringForKey:@"courses_name"];
            [self.nameLb sizeToFit];
            self.nameLb.width = ScreenWidth-16;
            self.timeLb.text = [dict safeStringForKey:@"courses_time"];
            self.timeLb.top = self.nameLb.bottom + 8;
            [self.img sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"courses_image"]]];
            self.playView.top = self.timeLb.bottom + 8;
            self.priceLb.text = [NSString stringWithFormat:@"课程售价:￥%@",[dict safeStringForKey:@"courses_price"]];
            self.priceLb.top = self.playView.bottom + 8;
            self.contentLb.text = [dict safeStringForKey:@"courses_content"];
            [self.contentLb sizeToFit];
            self.contentLb.top = self.priceLb.bottom + 8;
            [self.scrollView setContentSize:CGSizeMake(ScreenWidth, self.contentLb.bottom+8)];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)playAct:(UIButton *)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:NO];
    sender.hidden = YES;
    NSURL *url = [NSURL URLWithString:[dict safeStringForKey:@"courses_video"]];
    JPVideoPlayerControlView *contentView =  [[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil];
    contentView.delegate =self;
    self.img.userInteractionEnabled = YES;
    [self.img jp_playVideoWithURL:url
                          bufferingIndicator:[JPVideoPlayerBufferingIndicator new]
                                 controlView:contentView
                                progressView:nil
                               configuration:nil];
}

-(void)playerControlViewBtnClick{
    [self.img jp_pause];
}

- (void)timeTimerAction:(id)sender
{
    self.maskLb.hidden = NO;
    [self.img jp_stopPlay];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dealloc {
    if (self.img) {
        [self.img jp_stopPlay];
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)buyAct:(UIButton *)sender {
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"coursesgoods/immedPay" params:@{@"courses_goods_id":self.classId} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            WaitPayViewController *waitpay = [[WaitPayViewController alloc]init];
            waitpay.type = 2;
            waitpay.moneryNum =[dict safeStringForKey:@"courses_price"];
            waitpay.order_id = [data safeStringForKey:@"result"];
            [self.navigationController pushViewController:waitpay animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (IBAction)toServiceAct:(UIButton *)sender {
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:[[dict safeDictionaryForKey:@"kefu"]  safeStringForKey:@"chat_id"] conversationType:eConversationTypeChat];
    chatController.name = [[dict safeDictionaryForKey:@"kefu"]  safeStringForKey:@"member_name"];
    [self.navigationController pushViewController:chatController animated:YES];
}
@end
