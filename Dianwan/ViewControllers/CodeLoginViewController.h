//
//  CodeLoginViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface CodeLoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
- (IBAction)getCodeAct:(UIButton *)sender;
- (IBAction)confirmAct:(UIButton *)sender;

@end
