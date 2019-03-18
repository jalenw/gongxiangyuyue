//
//  ChatHistoryViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "ChatHistoryViewController.h"
#import "QRCodeViewController.h"
#import "FriendsViewController.h"
#import "ChatViewController.h"
@interface ChatHistoryViewController ()

@end

@implementation ChatHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.smView setArray: @[@{@"name":@"发起群聊",@"image":@"friend_group_chat"},@{@"name":@"我的推荐码",@"image":@"first_code"},@{@"name":@"约家列表",@"image":@"friend_date"}]];
    [self.smView setBlock:^(NSInteger index) {
        self.maskView.hidden = YES;
        if (index==0) {
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"ftoo150911" conversationType:eConversationTypeChat];
            [self.navigationController pushViewController:chatController animated:YES];
        }
        else if (index==1) {
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            
        }
    }];
    [self.view addSubview:self.maskView];
}

-(void)leftbarButtonDidTap:(UIButton *)button
{
    FriendsViewController *vc = [[FriendsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
     self.maskView.hidden = !self.maskView.hidden;
}
@end
