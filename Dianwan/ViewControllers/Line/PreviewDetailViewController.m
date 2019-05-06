//
//  PreviewDetailViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "PreviewDetailViewController.h"

@interface PreviewDetailViewController ()

@end

@implementation PreviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预告详情";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[_dict safeStringForKey:@"member_avatar"]]];
    self.userName.text = [_dict safeStringForKey:@"member_name"];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[_dict safeStringForKey:@"cover"]]];
    self.name.text = [_dict safeStringForKey:@"title"];
    self.type.text = [_dict safeStringForKey:@"class_name"];
    [self.type sizeToFit];
    self.type.width += 8;
    self.time.text = [NSString stringWithFormat:@"直播时间:%@", [_dict safeStringForKey:@"channel_time"]];
    self.content.text = [_dict safeStringForKey:@"content"];
    [self.content sizeToFit];
}
@end
