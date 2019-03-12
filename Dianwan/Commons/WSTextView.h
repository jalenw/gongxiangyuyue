//
//  WSTextView.h
//  PhotoTravel
//
//  Created by 黄哲麟 on 2018/1/14.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) IBInspectable NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
