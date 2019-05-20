//
//  LiveListViewController.h
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *liveBt;
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)toSearchViewAct:(UIButton *)sender;
- (IBAction)liveAct:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
