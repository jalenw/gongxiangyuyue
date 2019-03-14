//
//  SliderMenuView.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SliderMenuView : UIView
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,copy) void (^block)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
