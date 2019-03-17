//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>

//用于提现没有输入完毕确认键
@property(nonatomic,copy)void(^inputAllBlodk)(NSString  *pwNumber);

@property (nonatomic, strong) UITextField *textField;
/**
 *  清除密码
 */
- (void)clearUpPassword;


@end
