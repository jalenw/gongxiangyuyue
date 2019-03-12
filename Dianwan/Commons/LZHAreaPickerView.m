//
//  LZHAreaPickerView.m
//  kuxing
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHAreaPickerView.h"

@interface LZHAreaPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *pickerContainerView;
@end

@implementation LZHAreaPickerView


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
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 162)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;

    self.pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _pickerView.height+52)];
    self.pickerContainerView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _pickerView.height+8, ScreenWidth, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(comfirmDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerContainerView.top = ScreenHeight;
    [self addSubview:self.pickerContainerView];
    [self.pickerContainerView addSubview:button];
    [self.pickerContainerView addSubview:_pickerView];
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    [self.pickerView reloadComponent:0];
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


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.array.count;
}

#pragma mark - UIPickerViewDelegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
            NSDictionary *dict = [self.array objectAtIndex:row];
            NSString *name = [dict safeStringForKey:self.name];
            label.text = name;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (void)comfirmDidTap:(UIButton*)button{
    if (self.block) {
        NSInteger row1 = [_pickerView selectedRowInComponent:0];
        NSDictionary *dict = [self.array objectAtIndex:row1];
        self.block(dict);
    }
    [self hidePicker];
}


- (void)cancelDidTap:(UIButton*)button{
    [self hidePicker];
}

@end
