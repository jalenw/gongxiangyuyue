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
        //支付操作
        
                NSDictionary *params=@{
                                       @"pay_type":weakSelf.pay_type,
                                       @"order_id":weakSelf.order_id,
                                       @"member_paypwd":pwNumber
                                       };
                [SVProgressHUD show];
                [[ServiceForUser manager] postMethodName:@"minemachine/payMineMachineOrder" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
                    [weakSelf.pasView clearUpPassword];
                    [weakSelf.pasView.textField resignFirstResponder];
                    weakSelf.pwInputView.hidden = YES;
                    [SVProgressHUD dismiss];
                    if (status) {
                        PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
                        [weakSelf.navigationController pushViewController:paysuc animated:YES];
                    //把自己从视图栈删除
        //            NSMutableArray *tempMarray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        //            [tempMarray removeObject:self];
        //            [self.navigationController setViewControllers:tempMarray animated:YES];
        //            [self removeFromParentViewController];
        
                    }else{
                        [AlertHelper showAlertWithTitle:error];
                    }
                }];
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

@end
