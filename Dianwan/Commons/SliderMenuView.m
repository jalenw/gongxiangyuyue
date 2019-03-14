//
//  SliderMenuView.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "SliderMenuView.h"

@implementation SliderMenuView

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
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.width, self.height-20)];
    self.contentView.backgroundColor = [UIColor darkGrayColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    CGFloat top = 0;
    int i = 0;
    for (NSDictionary *dict in array) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = i;
        bt.frame = CGRectMake(0, top, self.width, 50);
        bt.backgroundColor = [UIColor clearColor];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(act:) forControlEvents:UIControlEventTouchUpInside];
        [bt setImage:[UIImage imageNamed:[dict safeStringForKey:@"image"]] forState:UIControlStateNormal];
        [bt setTitle:[dict safeStringForKey:@"name"] forState:UIControlStateNormal];
        [self.contentView addSubview:bt];
        i++;
        top = bt.bottom;
    }
}

-(void)act:(UIButton*)sender
{
    self.block(sender.tag);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.width-40, 20);
    CGContextAddLineToPoint(context,self.width-30, 10);
    CGContextAddLineToPoint(context,self.width-20, 20);
    CGContextClosePath(context);
    [[UIColor darkGrayColor] setFill];
    [[UIColor darkGrayColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end
