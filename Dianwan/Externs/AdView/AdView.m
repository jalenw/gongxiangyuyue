//
//  AdView.m
//  DotaSell
//
//  Created by 黄哲麟 on 2017/7/6.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "AdView.h"

@implementation AdView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.frame = CGRectMake(0, self.height - 30, self.width, 20);
    self.pageControl.centerX = self.width/2;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    [self.pageControl setNumberOfPages:array.count];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat x = 0;
    NSInteger i = 0;
    for (NSString *str in array) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.width, self.height)];
        img.userInteractionEnabled = YES;
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        [img setImageWithURL:[NSURL URLWithString:str]];
        [self.scrollView addSubview:img];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicked:)];
        [img addGestureRecognizer:tap];
        img.tag = i;
        i++;
        x = x+self.width;
    }
    [self.scrollView setContentSize:CGSizeMake(x, self.height)];
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerAct) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)timerAct
{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.index;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.index++;
    if (self.index == _array.count) {
        self.index = 0;
    }
}

-(void)clicked:(UITapGestureRecognizer*)gender
{
    self.block(gender.view.tag);
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth)+1;
    [self.pageControl setCurrentPage:page];
}
@end
