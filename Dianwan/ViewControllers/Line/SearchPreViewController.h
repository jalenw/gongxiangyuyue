//
//  SearchPreViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPreViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UITableView *listTableview;
@end

NS_ASSUME_NONNULL_END