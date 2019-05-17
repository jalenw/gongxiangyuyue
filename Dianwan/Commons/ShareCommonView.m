//
//  ShareCommonView.m
//  zingchat
//
//  Created by index on 16/12/26.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "ShareCommonView.h"

@implementation ShareCommonView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
    
    [backgroundButton addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundButton];
    
    backgroundButton.backgroundColor = RGBA(0, 0, 0, 0.7);
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-20)/2, ScreenHeight-80, 20, 20)];
    [cancelButton addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    
    
    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.width-60, 25)];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.center = CGPointMake(ScreenWidth/2, ScreenHeight/3-20);
//    [self addSubview:self.titleLabel];
//    
//    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.width-100, 30)];
//    self.desLabel.textColor = GrayColor2;
//    self.desLabel.textAlignment = NSTextAlignmentCenter;
//    self.desLabel.font = [UIFont systemFontOfSize:14];
//    self.desLabel.numberOfLines = 0;
//    self.desLabel.top = self.titleLabel.bottom+15;
//    [self addSubview:self.desLabel];

//    
//    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(15, self.height-100, ScreenWidth/2-50, 0.5)];
//    sepView.backgroundColor = GrayColor2;
//    [self addSubview:sepView];
//    
//    sepView = [[UIView alloc] initWithFrame:CGRectMake(15, self.height-100, ScreenWidth/2-50, 0.5)];
//    sepView.right = self.width-15;
//    sepView.backgroundColor = GrayColor2;
//    [self addSubview:sepView];
    
//    self.titleLabel.bottom = sepView.top/2.0 - 10;
//    self.desLabel.top = sepView.top/2.0 + 10;
    
//    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 21)];
//    sepLabel.textAlignment = NSTextAlignmentCenter;
//    sepLabel.textColor = GrayColor2;
//    sepLabel.font = [UIFont systemFontOfSize:14];
//    sepLabel.text = @"分享至";
//    sepLabel.center = CGPointMake(self.width/2, sepView.top);
//    [self addSubview:sepLabel];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-180, ScreenWidth, 180)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    UILabel *fenxiang = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.width, 44)];
    fenxiang.textColor = DarkColor1;
    fenxiang.text = @"分享";
    fenxiang.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:fenxiang];
    cancelButton.frame = CGRectMake(whiteView.width-44, 0, 44, 44);
    [whiteView addSubview:cancelButton];
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, whiteView.width, 1)];
    sepView.backgroundColor = GrayColor1;
    [whiteView addSubview:sepView];
    
    
    CGFloat buttonWidth = self.width/3;
    CGFloat buttonTop = ScreenHeight-100;
    UIColor *labelColor = GrayColor2;
    
    UIButton *_wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonTop, buttonWidth, 50)];
    [_wechatButton addTarget:self action:@selector(shareToWechat) forControlEvents:UIControlEventTouchUpInside];
    [_wechatButton setImage:[UIImage imageNamed:@"wechatShare"] forState:UIControlStateNormal];
    [self addSubview:_wechatButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, buttonWidth, 18)];
    label.textColor = labelColor;
    label.font = DefaultFontOfSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微信";
    [_wechatButton addSubview:label];
    
    UIButton *_timelineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, buttonTop, buttonWidth, 50)];
    [_timelineButton addTarget:self action:@selector(shareToTimeline) forControlEvents:UIControlEventTouchUpInside];
    [_timelineButton setImage:[UIImage imageNamed:@"timeLineShare"] forState:UIControlStateNormal];
    [self addSubview:_timelineButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, buttonWidth, 18)];
    label.textColor = labelColor;
    label.font = DefaultFontOfSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"朋友圈";
    [_timelineButton addSubview:label];
    
    
    UIButton *_qqButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*2, buttonTop, buttonWidth, 50)];
    [_qqButton addTarget:self action:@selector(shareToQQ) forControlEvents:UIControlEventTouchUpInside];
    [_qqButton setImage:[UIImage imageNamed:@"qqShare"] forState:UIControlStateNormal];
    [self addSubview:_qqButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, buttonWidth, 18)];
    label.textColor = labelColor;
    label.font = DefaultFontOfSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"QQ";
    [_qqButton addSubview:label];
    
    UIButton *_weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*3, buttonTop, buttonWidth, 50)];
    [_weiboButton addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
    [_weiboButton setImage:[UIImage imageNamed:@"weiboShare"] forState:UIControlStateNormal];
//    [self addSubview:_weiboButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, buttonWidth, 18)];
    label.textColor = labelColor;
    label.font = DefaultFontOfSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微博";
    [_weiboButton addSubview:label];
    
    
    UIButton *_copyButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*4, buttonTop, buttonWidth, 50)];
    [_copyButton addTarget:self action:@selector(copyLink) forControlEvents:UIControlEventTouchUpInside];
    [_copyButton setImage:[UIImage imageNamed:@"copyShare"] forState:UIControlStateNormal];
//    [self addSubview:_copyButton];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, buttonWidth, 18)];
    label.textColor = labelColor;
    label.font = DefaultFontOfSize(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"复制链接";
    [_copyButton addSubview:label];
    
    
}


- (void)shareToWechat{
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:self.shareParam onStateChanged:self.shareBlock];
}

- (void)shareToTimeline{
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:self.shareParam onStateChanged:self.shareBlock];
}

- (void)shareToQQ{
    [ShareSDK share:SSDKPlatformTypeQQ parameters:self.shareParam onStateChanged:self.shareBlock];
}

- (void)shareToWeibo{
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:self.shareParam onStateChanged:self.shareBlock];
}

- (void)copyLink{
    NSString *shareUrl = nil;
    id object = [self.shareParam objectForKey:@"url"];
    if ([object isKindOfClass:[NSURL class]]) {
        shareUrl = ((NSURL*)object).absoluteString;
    }
    if ([object isKindOfClass:[NSString class]]) {
        shareUrl = object;
    }
    if (shareUrl.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",shareUrl];
        [AlertHelper showAlertWithTitle:@"已复制链接"];
    }
    
}

- (void)hideShareView{
    if (self.block) {
        self.block(0);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
