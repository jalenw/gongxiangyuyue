//
//  ModifyPwViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyPwViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *npw;
@property (weak, nonatomic) IBOutlet UITextField *reNewPw;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
- (IBAction)doneAct:(UIButton *)sender;

@end
