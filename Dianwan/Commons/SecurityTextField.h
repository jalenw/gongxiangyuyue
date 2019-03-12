//
//  SecurityTextField.h
//  zingchat
//
//  Created by index on 16/8/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SecurityTextFieldDidFinsihBlock)(NSString *codeString);

@interface SecurityTextField : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isShowPass;

@property (nonatomic, strong) SecurityTextFieldDidFinsihBlock block;


- (void)setBlock:(SecurityTextFieldDidFinsihBlock)block;

- (void)updateCode;

@end
