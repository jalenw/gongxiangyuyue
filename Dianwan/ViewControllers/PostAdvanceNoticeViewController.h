//
//  PostAdvanceNoticeViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "WSTextView.h"
@interface PostAdvanceNoticeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *typeView;
- (IBAction)changeTimeAct:(UIButton *)sender;
- (IBAction)chooseTypeAct:(UIButton *)sender;
- (IBAction)closeTypeViewAct:(UIButton *)sender;
- (IBAction)confirmTypeAct:(UIButton *)sender;
- (IBAction)backAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
- (IBAction)addPicAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *timeTf;
@property (weak, nonatomic) IBOutlet UITextField *typeTf;
@property (weak, nonatomic) IBOutlet WSTextView *descTv;
- (IBAction)doneAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
