//
//  PayViewController.h
//  ShopFun
//
//  Created by noodle on 16/5/17.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PayDoneBlock)(void);
@interface PayViewController : UIViewController
@property(nonatomic,copy)PayDoneBlock block;
@property (strong,nonatomic) NSString *pay_sn;
@property (weak, nonatomic) IBOutlet UIView *payTypeView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)aliPayAct:(UIButton *)sender;
- (IBAction)wechatPayAct:(UIButton *)sender;
- (IBAction)closeViewAct:(UIButton *)sender;
- (IBAction)showPayView:(UIButton *)sender;
- (IBAction)closePayView:(UIButton *)sender;
- (IBAction)payAct:(UIButton *)sender;

@end
