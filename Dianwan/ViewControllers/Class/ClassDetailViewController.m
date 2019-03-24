//
//  ClassDetailViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/24.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "ClassDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ClassDetailViewController ()
{
    NSDictionary *dict;
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
    MPMoviePlayerViewController *mPMoviePlayerViewController;
    mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[dict safeStringForKey:@"course_video"]]];
    mPMoviePlayerViewController.view.frame = ScreenBounds;
    [self presentViewController:mPMoviePlayerViewController animated:YES completion:nil];
}
@end
