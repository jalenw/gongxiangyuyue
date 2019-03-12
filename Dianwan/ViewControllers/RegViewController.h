//
//  RegViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface RegViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
- (IBAction)doneAct:(UIButton *)sender;
- (IBAction)getCodeAct:(UIButton *)sender;
@end
