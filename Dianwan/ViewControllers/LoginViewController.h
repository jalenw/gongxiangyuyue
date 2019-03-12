//
//  LoginViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)regAct:(UIButton *)sender;
- (IBAction)codeLoginAct:(UIButton *)sender;
- (IBAction)forgetAct:(UIButton *)sender;
- (IBAction)loginAct:(UIButton *)sender;
- (IBAction)backAct:(UIButton *)sender;

@end
