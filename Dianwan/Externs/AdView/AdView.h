//
//  AdView.h
//  DotaSell
//
//  Created by 黄哲麟 on 2017/7/6.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *array;
@property (nonatomic) int index;
@property (nonatomic,copy) void (^block)(NSInteger index);
@end
