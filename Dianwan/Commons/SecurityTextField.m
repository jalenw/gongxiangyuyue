//
//  SecurityTextField.m
//  zingchat
//
//  Created by index on 16/8/12.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "SecurityTextField.h"

@interface SecurityTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *codeLabelArray;
@property (nonatomic, strong) UIView *codeContainerView;

@end

@implementation SecurityTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.codeLabelArray = [[NSMutableArray alloc] init];
   
    
    self.textField = [[UITextField alloc] init];
    self.textField.hidden = YES;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    self.codeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.codeContainerView.centerX = self.width/2;
    [self addSubview:self.codeContainerView];
    
    UIColor *borderColor = RGB(196, 196, 196);
    
    CGFloat oneWidth = (self.width-15)/6;
    CGFloat oneHeight = oneWidth;
    for (int i = 0; i < 6; ++i) {
        
        UIView *labelContainerView = [[UIView alloc] initWithFrame:CGRectMake((oneWidth+3)*i, 0, oneWidth, oneHeight)];
        labelContainerView.layer.borderColor = borderColor.CGColor;
        labelContainerView.layer.borderWidth = 1.0f;
        labelContainerView.layer.cornerRadius = 4;
        labelContainerView.clipsToBounds = YES;
        labelContainerView.backgroundColor = [UIColor whiteColor];
        
        
        [self.codeContainerView addSubview:labelContainerView];
        
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, oneWidth, oneHeight)];
        codeLabel.textColor = borderColor;
        codeLabel.text = @"";
        codeLabel.font = [UIFont systemFontOfSize:24];
        codeLabel.textAlignment = NSTextAlignmentCenter;
        [self.codeLabelArray addObject:codeLabel];
        [labelContainerView addSubview:codeLabel];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.codeContainerView.bounds];
    [self.codeContainerView addSubview:button];
    [button addTarget:self action:@selector(beginInput:) forControlEvents:UIControlEventTouchUpInside];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)beginInput:(UIButton*)button{
    [self.textField becomeFirstResponder];
}

- (void)updateCode{
    for (int i = 0; i < self.codeLabelArray.count; ++i) {
        UILabel *label = self.codeLabelArray[i];
        if (i < self.textField.text.length) {
            if (self.isShowPass) {
                label.text = [self.textField.text substringWithRange:NSMakeRange(i, 1)];
                label.top = 0;
            }else{
                label.text = @"*";
                label.top = 5;
            }
        }else{
            label.text = @"";
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *afterString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (afterString.length > 6) {
        return NO;
    }
    return YES;
}


- (void)textFieldDidChange:(UITextField*)textField{
    [self updateCode];
    if(self.textField.text.length >= 6){
        [self.textField resignFirstResponder];
        if (self.block) {
            self.block(self.textField.text);
        }
        
        self.textField.text = @"";
        [self updateCode];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
