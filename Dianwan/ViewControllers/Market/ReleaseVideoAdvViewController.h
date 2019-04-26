//
//  ReleaseVideoAdvViewController.h
//  Dianwan
//
//  Created by Yang on 2019/4/1.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSTextView.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReleaseVideoAdvViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *advTitleTF;
@property (weak, nonatomic) IBOutlet UITextField *redEnvelope;
@property (weak, nonatomic) IBOutlet UITextField *remainingCountTF;
@property (weak,nonatomic) IBOutlet WSTextView *advTextView;
@property (weak, nonatomic) IBOutlet UIButton *goldCoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *remainingBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property (weak, nonatomic) IBOutlet UILabel *unitLb;
@property (weak, nonatomic) IBOutlet UILabel *showUnitLb;
@end

NS_ASSUME_NONNULL_END
