//
//  ModifyPwViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyPwViewController : BaseViewController
@property (nonatomic)BOOL forPayPw;
@property (weak, nonatomic) IBOutlet UITextField *pw;
@property (weak, nonatomic) IBOutlet UITextField *npw;
@property (weak, nonatomic) IBOutlet UITextField *reNewPw;
- (IBAction)doneAct:(UIButton *)sender;

@end
