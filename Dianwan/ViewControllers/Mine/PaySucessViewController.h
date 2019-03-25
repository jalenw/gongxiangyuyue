//
//  PaySucessViewController.h
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaySucessViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *bt;
@property (nonatomic,strong) NSString *btText;
@property (nonatomic,copy) void (^block)(void);
- (IBAction)toWhereAct:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
