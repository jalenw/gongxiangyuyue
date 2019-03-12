//
//  LZHDatePickerView.h
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LZHDateChooseBlock)(NSDate *date);

@interface LZHDatePickerView : UIView


@property (nonatomic, strong) LZHDateChooseBlock block;
@property (nonatomic, strong) UIDatePicker *datePicker;
- (void)setBlock:(LZHDateChooseBlock)block;
- (void)showPicker;
- (void)hidePicker;

@end
