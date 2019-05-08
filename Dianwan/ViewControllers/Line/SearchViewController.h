//
//  SearchViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/7.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UITableView *listTableview;

@end
