//
//  PostYueJiaViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "WSTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostYueJiaViewController : BaseViewController
@property (strong,nonatomic) NSString *chat_id;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *bt;
@property (weak, nonatomic) IBOutlet UITextField *marketPrice;
@property (weak, nonatomic) IBOutlet UITextField *cost;
@property (weak, nonatomic) IBOutlet WSTextView *desc;
- (IBAction)typeAct:(UIButton *)sender;
- (IBAction)doneAct:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
