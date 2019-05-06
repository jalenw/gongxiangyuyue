//
//  GroupMemberListViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupMemberListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSString *group_id;
@end

NS_ASSUME_NONNULL_END
