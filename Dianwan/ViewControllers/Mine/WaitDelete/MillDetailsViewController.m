//
//  MillDetailsViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MillDetailsViewController.h"

@interface MillDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *deatialsLabel;
@property (strong, nonatomic) IBOutlet UIView *settlementView;
@property (weak, nonatomic) IBOutlet UITextField *iconInputTF;
@property (weak, nonatomic) IBOutlet UILabel *shareMoneryLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property(nonatomic,strong)NSDictionary *result;
@property (weak, nonatomic) IBOutlet UIButton *recoviewBtn;

@end

@implementation MillDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"矿机名称";
    [self requestData];
    self.settlementView.frame =self.view.bounds;
    self.settlementView.hidden = YES;
    [self.view addSubview:self.settlementView];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    _deatialsLabel.attributedText = string;
    _deatialsLabel.textAlignment = NSTextAlignmentJustified;
    _deatialsLabel .alpha = 1.0;
}
-(void)requestData{
    NSDictionary *params = @{@"order_id":self.order_id};
    [[ServiceForUser manager] postMethodName:@"minemachine/mineMachineDetail" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            _result = [data safeDictionaryForKey:@"result"];
            [self setupUI];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        
    }];
}

-(void)setupUI{
    self.shareMoneryLabel.text = [self.result safeStringForKey:@"mine_machine_bonus"];
    self.coinLabel.text = [self.result safeStringForKey:@"mine_machine_gold"];
}

- (IBAction)recoviewCionAct:(UIButton *)sender {
    NSDictionary *params =@{};
    [[ServiceForUser manager] postMethodName:@"minemachine/oneKeyCoinCollection" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [AlertHelper showAlertWithTitle:[data safeStringForKey:@"result"]];
            self.recoviewBtn.hidden = YES;
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
    
//    self.settlementView.hidden =NO;
    
}

//结算金币
- (IBAction)settlementAct:(UIButton *)sender {
    
    
     [SVProgressHUD showrealImage:[UIImage imageNamed:@"确定"] status:@"确认收币"];
    
}
- (IBAction)cancleSettlementAct:(UIButton *)sender {
    self.settlementView.hidden = YES;
    self.iconInputTF.text=@"";
}

@end
