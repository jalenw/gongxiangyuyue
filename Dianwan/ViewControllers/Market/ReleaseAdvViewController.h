//
//  ReleaseAdvViewController.h
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "WSTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReleaseAdvViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *advTitleTF;
@property (weak, nonatomic) IBOutlet UITextField *redEnvelope;
@property (weak, nonatomic) IBOutlet UITextField *remainingCountTF;
@property (weak,nonatomic) IBOutlet WSTextView *advTextView;
@property (weak, nonatomic) IBOutlet UIButton *goldCoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *remainingBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitLb;
@property (weak, nonatomic) IBOutlet UILabel *showUnitLb;

@end

NS_ASSUME_NONNULL_END
