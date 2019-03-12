//
//  BindingPhoneViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/5.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface BindingPhoneViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
- (IBAction)getCodeAct:(UIButton *)sender;
- (IBAction)confirmAct:(UIButton *)sender;
@end
