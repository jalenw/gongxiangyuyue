//
//  ZTTabBar.m
//  SinaWeibo
//
//  Created by user on 15/10/16.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "ZTTabBar.h"

@interface ZTTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;//中间按钮
@property (nonatomic, weak) UILabel *nameLb;//按钮下面显示的字符
@end

@implementation ZTTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_mid"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_mid"] forState:UIControlStateHighlighted];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_mid"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_mid"] forState:UIControlStateHighlighted];

        plusBtn.size = plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 9)];
        label.text = @"";
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = RGB(154, 154, 154);
        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        self.nameLb = label;
    }
    return self;
}

/**
 *  加号按钮点击
 */
- (void)plusBtnClick
{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    self.plusBtn.centerX = self.width*0.5;
    self.plusBtn.centerY = self.height*0.5-18;
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.left = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
    
    self.nameLb.centerX = self.width*0.5;
    self.nameLb.top = self.height - self.nameLb.height - 7.5;
}

@end
