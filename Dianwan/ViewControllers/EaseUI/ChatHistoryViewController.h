//
//  ChatHistoryViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/14.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderMenuView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatHistoryViewController : EaseConversationListViewController
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet SliderMenuView *smView;
- (IBAction)removeMaskViewAct:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
