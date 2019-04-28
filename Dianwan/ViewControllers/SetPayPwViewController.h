//
//  SetPayPwViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface SetPayPwViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *pw;
@property (weak, nonatomic) IBOutlet UITextField *rpw;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *phone;

- (IBAction)doneAct:(UIButton *)sender;

@end
