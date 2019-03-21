//
//  AdvDetailsViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AdvDetailsViewController.h"

@interface AdvDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property(nonatomic,strong)NSArray *AdsData;
@property(nonatomic,strong)NSDictionary *result;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (nonatomic, weak) UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIButton *seeTimeBtn;
@property(nonatomic,strong)   NSTimer *codeTimer;
@property (strong, nonatomic) IBOutlet UIView *redbagPackageView;
@property (weak, nonatomic) IBOutlet UILabel *moneryLabel;
@end

@implementation AdvDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    
    self.seeTimeBtn.enabled =NO;
     _mainScrollview.showsVerticalScrollIndicator = NO;
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_codeTimer invalidate];
}


-(void)requestData{
    NSDictionary *params=@{@"adv_id":@(self.adv_id)};
    [[ServiceForUser manager] postMethodName:@"advertising/advInfo" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            self.result = [data safeDictionaryForKey:@"result"];
    
            if([self.result safeArrayForKey:@"imgs"].count>0){
                self.AdsData = [self.result safeArrayForKey:@"imgs"];
            }
            else
            {
               self.AdsData = [[self.result safeStringForKey:@"imgs"] componentsSeparatedByString:@","];
            }
            if([self.result safeIntForKey:@"receive"]==[self.result safeIntForKey:@"num"]){
                self.seeTimeBtn.hidden = YES;
            }else{
                __block int i = 10;
                _codeTimer= [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    i--;
                    self.seeTimeBtn.titleLabel.text = [NSString stringWithFormat:@"观看倒计时%d秒",i];
                    [self.seeTimeBtn setTitle:[NSString stringWithFormat:@"观看倒计时%d秒",i] forState:UIControlStateNormal];
                    if (i==0) {
                        [timer invalidate];
                        self.seeTimeBtn.enabled = YES;
                        [self.seeTimeBtn setTitle:@"领取红包" forState:UIControlStateNormal];
                    }
                }];
                [[NSRunLoop mainRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
            }
            [self setupUI];
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        
    }];
}

-(void)setupUI{
    self.title =[self.result safeStringForKey:@"title"];
    self.moneryLabel.text = [NSString stringWithFormat:@"%@元",[self.result safeStringForKey:@"price"]];
    //测试
//    self.AdsData = @[@"http://www.public66.cn/uploads/home/common/default_user_portrait.gif",@"http://www.public66.cn/uploads/home/common/default_user_portrait.gif",@"http://www.public66.cn/uploads/home/common/default_user_portrait.gif"];
 
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth - 50) * 0.53125 + 40)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.contentSize = CGSizeMake(self.AdsData.count * (ScreenWidth - 40) + 40, 170);
    backScrollView.showsHorizontalScrollIndicator = NO;
    [self.mainScrollview addSubview:backScrollView];
    self.backScrollView = backScrollView;
    for (int i = 0; i < self.AdsData.count; i++)
    {
        UIImageView *shadowView = [[UIImageView alloc] init];
        shadowView.backgroundColor = [UIColor redColor];
        shadowView.frame = CGRectMake(25 + (ScreenWidth - 40) * i, 15, ScreenWidth - 50, (ScreenWidth - 50) * 0.53125);
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 5.0;
        shadowView.layer.shadowOpacity = 0.3;
        shadowView.layer.shadowOffset = CGSizeMake(-4, 4);
        shadowView.userInteractionEnabled = YES;
        shadowView.tag = i;
        shadowView.layer.cornerRadius  = 4;
        shadowView.layer.masksToBounds = YES;
        CALayer *AdsView = [[CALayer alloc] init];
        AdsView.frame = CGRectMake(0, 0, ScreenWidth - 50, (ScreenWidth - 50) * 0.53125);
        [shadowView sd_setImageWithURL:[NSURL URLWithString:self.AdsData[i]]];
        [shadowView.layer addSublayer:AdsView];
        [self.backScrollView addSubview:shadowView];
        
    }
    //解析内容
    UILabel *contentLabel = [[UILabel alloc]init];
    //测试
//    NSString * content =@"温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。温馨提示 \n 1.矿机产币周期为100天，每日上午11：00——下午22：00每小时产币6枚，产币后随时可以收取，产币达到198枚未收取时矿机暂停产币，收取后继续产币。\n 2.从第一台矿机售出起，每100天为一个结算日，结算日暂停产币，结算日在首页有提示。";
    
    NSString *content =[_result safeStringForKey:@"content"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textAlignment = NSTextAlignmentJustified;
    contentLabel .alpha = 1.0;
    contentLabel.numberOfLines=0;
    CGFloat height = [Tooles calculateTextHeight:(ScreenWidth -32) Content:content fontSize:15];
    contentLabel.frame = CGRectMake(16, backScrollView.height +16, ScreenWidth-32, height);
    
    [self.mainScrollview addSubview:contentLabel];
    if(height > self.mainScrollview.contentSize.height - backScrollView.bottom -16){
        self.mainScrollview.contentSize = CGSizeMake(ScreenWidth, height+backScrollView.bottom + 16);
    }
    
}

- (IBAction)receiveRedenvelope:(UIButton *)sender {
    self.redbagPackageView.frame = self.view.bounds;
    [self.view addSubview:self.redbagPackageView];
    
    
    
    
    
}

- (IBAction)receiveAct:(UIButton *)sender {
   
    [SVProgressHUD show];
    NSDictionary *params=@{@"adv_id":@(self.adv_id)};
    [[ServiceForUser manager] postMethodName:@"advertising/advReceive" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            [AlertHelper showAlertWithTitle:@"领取红包成功" duration:2];
            self.redbagPackageView.hidden = YES;
            self.receiveBtn.enabled = NO;
            self.seeTimeBtn.hidden = YES;
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
    
}


@end
