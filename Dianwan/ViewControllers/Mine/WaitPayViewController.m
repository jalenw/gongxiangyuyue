//
//  WaitPayViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "WaitPayViewController.h"
#import "PaySucessViewController.h"
#import "SYPasswordView.h"
#import "AlreadybuyViewController.h"
@interface WaitPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;
@property(nonatomic,strong)NSString *pay_type;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIView *pwInputView;
@property (nonatomic, strong) SYPasswordView *pasView;
@property (weak, nonatomic) IBOutlet UIView *pwView;
@end

@implementation WaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线支付";
    self.pay_type=@"money";
    self.moneyCountLabel.text =[NSString stringWithFormat:@"¥%0.2f",[_moneryNum floatValue]];
    
    
    
    //创建密码输入控价
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(20, 93, 288, 48)];
    //zyf
    self.pasView.layer.cornerRadius = 5;
    self.pasView.layer.masksToBounds =YES;
      __weak typeof(self) weakSelf = self;
    self.pasView.inputAllBlodk = ^(NSString *pwNumber) {
        if (weakSelf.type==0) {
            
        }
        if (weakSelf.type==1) {
            [weakSelf payForMine:pwNumber];
        }
        if (weakSelf.type==2) {
            [weakSelf payForClass:pwNumber];
        }
    };
    [self.pwView addSubview:_pasView];
    self.pwInputView.frame = self.view.bounds;
    self.pwInputView.hidden = YES;
    [self.pasView.textField resignFirstResponder];
    [self.view addSubview:self.pwInputView];
}
- (IBAction)menuAct:(UIButton *)sender {
    if (sender.tag == 101) {
        self.weichatPayBtn.selected = YES;
        self.aliPayBtn.selected = NO;
        self.yuePayBtn.selected = NO;
        self.pay_type = @"wxpay_app";
    }
    if (sender.tag == 102) {
        self.weichatPayBtn.selected = NO;
        self.aliPayBtn.selected = YES;
        self.yuePayBtn.selected = NO;
        self.pay_type = @"alipay_app";
    }
    if (sender.tag == 103) {
        self.weichatPayBtn.selected = NO;
        self.aliPayBtn.selected = NO;
        self.yuePayBtn.selected = YES;
        self.pay_type = @"money";
    }
}
- (IBAction)hiddenInputViewAct:(UIButton *)sender {
    [self.pasView clearUpPassword];
    [self.pasView.textField resignFirstResponder];
    self.pwInputView.hidden =YES;
}

- (IBAction)toPayAct:(UIButton *)sender {
    if([self.pay_type isEqualToString:@"alipay_app"] ||[self.pay_type isEqualToString:@"wxpay_app"]  ){
        [AlertHelper showAlertWithTitle:@"功能暂未开通"];
    }else{
        self.pwInputView.hidden = NO;
        [self.pasView.textField becomeFirstResponder];
    }
}

-(void)payForMine:(NSString*)pwNumber
{
    NSDictionary *params=@{
                           @"pay_type":self.pay_type,
                           @"order_id":self.order_id,
                           @"member_paypwd":pwNumber
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"minemachine/payMineMachineOrder" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            [self.navigationController pushViewController:paysuc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)payForClass:(NSString*)pwNumber
{
    NSDictionary *params=@{
                           @"order_sn":self.order_id,
                           @"member_paypwd":pwNumber
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"coursesgoods/coursesGoodsBalancePay" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            paysuc.btText = @"查看购买课程";
            [paysuc setBlock:^{
                AlreadybuyViewController *alreadBuy = [[AlreadybuyViewController alloc]init];
                [self.navigationController pushViewController:alreadBuy animated:YES];
            }];
            [self.navigationController pushViewController:paysuc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}
@end
