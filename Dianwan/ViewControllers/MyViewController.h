//
//  MyViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface MyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
- (IBAction)loginAct:(UIButton *)sender;
- (IBAction)menuAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *userCoverimageView;
@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;//下线
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;//租用
@end
