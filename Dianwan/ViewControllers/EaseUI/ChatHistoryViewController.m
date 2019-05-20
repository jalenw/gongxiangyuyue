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
    [self.smView setArray: @[@{@"name":@"添加好友",@"image":@"friend_group_chat"},@{@"name":@"我的推荐码",@"image":@"first_code"},@{@"name":@"平台说明",@"image":@"first_?"}]];
    [self.smView setBlock:^(NSInteger index) {
        self.maskView.hidden = YES;
        if (index==0) {
            CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
            controller.address = [NSString stringWithFormat:@"%@%@",web_url,@"dist/chat"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (index==1) {
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
            controller.address = [NSString stringWithFormat:@"%@wap/mall/info.html?article_id=51",web_url];
            [self.navigationController pushViewController:controller animated:YES];
//            CommonUIWebViewController *controller = [[CommonUIWebViewController alloc] init];
//            controller.address = [NSString stringWithFormat:@"%@%@",web_url,@"dist/appointment"];
//            [self.navigationController pushViewController:controller animated:YES];
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
- (IBAction)removeMaskViewAct:(UIButton *)sender {
    self.maskView.hidden = YES;
}
@end
