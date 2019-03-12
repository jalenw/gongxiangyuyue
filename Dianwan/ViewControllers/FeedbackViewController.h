//
//  FeedbackViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/8.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "WSTextView.h"
@interface FeedbackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet WSTextView *textView;
- (IBAction)doneAct:(UIButton *)sender;

@end
