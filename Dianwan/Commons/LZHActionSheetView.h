//
//  LZHActionSheetView.h
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LZHActionSheetViewBlock)(NSInteger index, NSString *title);//-1为取消

@interface LZHActionSheetView : UIView

+ (instancetype)createWithTitleArray:(NSArray*)array;

@property (nonatomic, readonly) NSArray<NSString*> *actionTitleArray;
@property (nonatomic, readonly) UIButton *cancelButton;
@property (nonatomic, strong) LZHActionSheetViewBlock block;

- (NSArray*)getActionButtons;

- (void)setBlock:(LZHActionSheetViewBlock)block;

- (void)show;

- (void)hide;

@end
