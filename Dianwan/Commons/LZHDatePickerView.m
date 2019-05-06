//
//  LZHDatePickerView.m
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHDatePickerView.h"


@interface LZHDatePickerView()
{
    
}

@property (nonatomic, strong) UIView *pickerContainerView;


@end


@implementation LZHDatePickerView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
    self.frame = ScreenBounds;
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    UIButton *maskButton = [[UIButton alloc] initWithFrame:ScreenBounds];
    [maskButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskButton];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.width = ScreenWidth;
    self.pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.datePicker.height+52)];
    self.pickerContainerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.datePicker.height+8, ScreenWidth, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(comfirmDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pickerContainerView.top = ScreenHeight;
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView addSubview:button];
    [self.pickerContainerView addSubview:self.datePicker];

    
}


- (void)showPicker{
    [AppDelegateInstance.window addSubview:self];
    [UIView animateWithDuration:0.275 animations:^{
        _pickerContainerView.bottom = self.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePicker{
    [UIView animateWithDuration:0.275 animations:^{
        _pickerContainerView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)comfirmDidTap:(UIButton*)button{
    if (self.block) {
        self.block(self.datePicker.date);
    }
    [self hidePicker];
}


- (void)cancelDidTap:(UIButton*)button{
    [self hidePicker];
}

-(void)setDatePickerMode:(UIDatePickerMode)mode
{
    self.datePicker.datePickerMode = mode;
}
@end
