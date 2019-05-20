//
//  LiveAndVideoViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "LZHTabScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveAndVideoViewController : LZHTabScrollViewController
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)closeTypeViewAct:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
