//
//  UserViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/19.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface UserViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *avatarBt;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *city;
@property (weak, nonatomic) IBOutlet UIButton *birthday;
@property (weak, nonatomic) IBOutlet UITextField *realName;
- (IBAction)avatarAct:(UIButton *)sender;
- (IBAction)jobAct:(UIButton *)sender;
- (IBAction)cityAct:(UIButton *)sender;
- (IBAction)dateAct:(UIButton *)sender;
- (IBAction)sexAct:(UIButton *)sender;
@end
