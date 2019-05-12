//
//  AddLineViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/19.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddLineViewController : BaseViewController
@property (nonatomic,copy) void (^block)(NSDictionary *dict);
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bts;
@property (weak, nonatomic) IBOutlet UIView *costView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UITextField *costTf;
@property (weak, nonatomic) IBOutlet UITextField *typeTf;
@property (weak, nonatomic) IBOutlet UIView *typeView;
- (IBAction)addImgAct:(UIButton *)sender;
- (IBAction)backAct:(UIButton *)sender;
- (IBAction)doneAct:(UIButton *)sender;
- (IBAction)menuAct:(UIButton *)sender;
- (IBAction)liveProtocol:(UIButton *)sender;
- (IBAction)changeTypeAct:(UIButton *)sender;
- (IBAction)closeTypeViewAct:(id)sender;
- (IBAction)confirmTypeViewAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
