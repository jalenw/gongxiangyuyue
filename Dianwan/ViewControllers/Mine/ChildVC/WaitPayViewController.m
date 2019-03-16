//
//  WaitPayViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "WaitPayViewController.h"
#import "PaySucessViewController.h"

@interface WaitPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;
@property(nonatomic,strong)NSString *pay_type;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end

@implementation WaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线支付";
    self.pay_type=@"money";
    self.moneyCountLabel.text =[NSString stringWithFormat:@"¥%0.2f",[_moneryNum floatValue]];
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

- (IBAction)toPayAct:(UIButton *)sender {
    if([self.pay_type isEqualToString:@"alipay_app"] ||[self.pay_type isEqualToString:@"wxpay_app"]  ){
        [AlertHelper showAlertWithTitle:@"功能暂未开通"];
    }else{
        NSDictionary *params=@{
                               @"pay_type":self.pay_type,
                               @"order_id":self.order_id,
                               @"member_paypwd":@"222222"
                               };
        [SVProgressHUD show];
        [[ServiceForUser manager] postMethodName:@"minemachine/payMineMachineOrder" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
                [self.navigationController pushViewController:paysuc animated:YES];
            //把自己从视图栈删除
//            NSMutableArray *tempMarray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//            [tempMarray removeObject:self];
//            [self.navigationController setViewControllers:tempMarray animated:YES];
//            [self removeFromParentViewController];
            
            }else{
                [AlertHelper showAlertWithTitle:error];
            }
        }];
        
    }
    
    
}

@end
