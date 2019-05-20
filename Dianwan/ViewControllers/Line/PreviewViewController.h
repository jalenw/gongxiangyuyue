//
//  PreviewViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *listTableview;
- (IBAction)toSearchAct:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
