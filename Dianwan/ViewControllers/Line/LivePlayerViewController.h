//
//  LivePlayerViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LivePlayerViewController : BaseViewController
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic) BOOL forPush;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *contentTf;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UIButton *rewardBt;
@property (weak, nonatomic) IBOutlet UIView *rewardContentView;
@property (weak, nonatomic) IBOutlet UITextField *rewardTf;

- (IBAction)closeAct:(UIButton *)sender;
- (IBAction)shareAct:(UIButton *)sender;
- (IBAction)sendAct:(UIButton *)sender;
- (IBAction)rewardAct:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
