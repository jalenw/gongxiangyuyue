//
//  LZHAreaPickerView.h
//  kuxing
//
//  Created by mac on 17/4/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LZHAreaPickerViewBlock)(NSDictionary *dict);

@interface LZHAreaPickerView : UIView
@property (nonatomic, strong) NSArray *array;//字典数组
@property (nonatomic, strong) NSString *name;//字典key
@property (nonatomic, strong) LZHAreaPickerViewBlock block;
@property (nonatomic, readonly) UIPickerView *pickerView;
- (void)setBlock:(LZHAreaPickerViewBlock)block;
- (void)showPicker;
- (void)hidePicker;

@end
