//
//  LZHTabScrollViewController.h
//  kuxing
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface LZHTabScrollViewController : BaseViewController{
    CGFloat _lastOffsetX;
}

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *currentController;
@property (nonatomic, strong) UIScrollView *topHeadScrollView;
@property (strong, nonatomic) UIView *topHeaderView;
@property (nonatomic, strong) NSArray *topButtonArray;
@property (nonatomic, strong) NSArray *controllerArray;
//每次出现后会变nil
@property (nonatomic, strong) NSNumber *showControllerAtIndexWhenAppear;


- (void)setupTapScroll;


//继承需要重写的方法

- (BOOL)isAllowScroll;
//设置controller
- (void)setupControllers;
//设置标题
- (NSArray<NSString*>*)buttonTitleArray;
//设置顶部View
- (UIView*)createTopHeaderView;
//设置下滑线的偏移位置
- (CGFloat)indicatorOffset;
//设置下滑线的长度
-(CGFloat)indicatorWidth;
//切换controller时调用
- (void)currentControllerDidChange;
//准备切换Controller时调用
- (BOOL)currentControllerShouldChangeWithIndex:(NSInteger)index;
//tab通常颜色
- (UIColor*)normalTabTextColor;
//tab选中颜色
- (UIColor*)selectTabTextColor;
//指示线的颜色
- (UIColor*)indicatorColor;
//设置按钮背景颜色
-(UIColor *)BtnbackgroundColor;
//设置标示view的顶部距离
- (CGFloat)indicatorTop;

- (CGFloat)topHeaderWidth;

@end
