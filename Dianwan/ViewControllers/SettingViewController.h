//
//  SettingViewController.h
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)logoutAct:(UIButton *)sender;
@end
