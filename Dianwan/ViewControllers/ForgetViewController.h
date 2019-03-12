//
//  ForgetViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgetViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
- (IBAction)getCodeAct:(UIButton *)sender;
- (IBAction)confirmAct:(UIButton *)sender;

@end
