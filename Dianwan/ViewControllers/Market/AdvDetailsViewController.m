//
//  AdvDetailsViewController.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AdvDetailsViewController.h"
#import "AdView.h"
#import "JPVideoPlayerKit.h"
@interface AdvDetailsViewController ()<JPVideoPlayerControlViewDelegate>
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
    
     self.seeTimeBtn.enabled =YES;
    [self.seeTimeBtn setTitle:@"领取红包" forState:UIControlStateNormal];
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
//            if([self.result safeIntForKey:@"receive"]==[self.result safeIntForKey:@"num"]){
//                self.seeTimeBtn.hidden = YES;
//            }else{
//                __block int i = 10;
//                _codeTimer= [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                    i--;
//                    self.seeTimeBtn.titleLabel.text = [NSString stringWithFormat:@"观看倒计时%d秒",i];
//                    [self.seeTimeBtn setTitle:[NSString stringWithFormat:@"观看倒计时%d秒",i] forState:UIControlStateNormal];
//                    if (i==0) {
//                        [timer invalidate];
//                        self.seeTimeBtn.enabled = YES;
//                        [self.seeTimeBtn setTitle:@"领取红包" forState:UIControlStateNormal];
//                    }
//                }];
//                [[NSRunLoop mainRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
//            }
            [self setupUI];
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
        
    }];
}
-(void)back{
    if ([self.result safeStringForKey:@"video"].length>0) {
        [self.backScrollView jp_pause];
    }
    [super back];
}

-(void)setupUI{
    self.title =[self.result safeStringForKey:@"title"];
    self.moneryLabel.text = [NSString stringWithFormat:@"%@元",[self.result safeStringForKey:@"price"]];
//    AdView *view= [[AdView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth - 50) * 0.53125 + 40)];
////    view.frame =CGRectMake(0, 0, ScreenWidth, (ScreenWidth - 50) * 0.53125 + 40);
//    [self.mainScrollview addSubview:view];
//     [view setArray:self.AdsData];
    
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth - 50) * 0.53125 + 40)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.contentSize = CGSizeMake(self.AdsData.count * (ScreenWidth - 40) + 40, 170);
    backScrollView.showsHorizontalScrollIndicator = NO;
    [self.mainScrollview addSubview:backScrollView];
    self.backScrollView = backScrollView;
    if([self.result safeIntForKey:@"type"] == 1){
        NSURL *url = [NSURL URLWithString:[self.result safeStringForKey:@"video"]];
        JPVideoPlayerControlView *contentView =  [[JPVideoPlayerControlView alloc] initWithControlBar:nil blurImage:nil];
        contentView.delegate =self;
        self.backScrollView.userInteractionEnabled = YES;
        [self.backScrollView jp_playVideoWithURL:url
                                          bufferingIndicator:[JPVideoPlayerBufferingIndicator new]
                                                 controlView:contentView
                                                progressView:nil
                                               configuration:nil];
        [self.backScrollView jp_pause];
    }else{
        for (int i = 0; i < self.AdsData.count; i++)
        {
            UIImageView *shadowView = [[UIImageView alloc] init];
            //        shadowView.backgroundColor = [UIColor redColor];
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
        
    }
   
    
    
    
    
    
    
    
    //解析内容
    UILabel *contentLabel = [[UILabel alloc]init];
   
    NSString *content =[_result safeStringForKey:@"content"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textAlignment = NSTextAlignmentJustified;
    contentLabel .alpha = 1.0;
    contentLabel.numberOfLines=0;
    CGFloat height = [Tooles calculateTextHeight:(ScreenWidth -32) Content:content fontSize:15];
    contentLabel.frame = CGRectMake(16, backScrollView.height +16, ScreenWidth-32, height);
//     contentLabel.frame = CGRectMake(16, view.height +16, ScreenWidth-32, height);
    
    [self.mainScrollview addSubview:contentLabel];
//    if(height > self.mainScrollview.contentSize.height - backScrollView.bottom -16){
//        self.mainScrollview.contentSize = CGSizeMake(ScreenWidth, height+backScrollView.bottom + 16);
////    }
//    if(height > self.mainScrollview.contentSize.height - view.bottom -16){
//        self.mainScrollview.contentSize = CGSizeMake(ScreenWidth, height+view.bottom + 16);
//    }
    
}

//-(void)playerControlViewBtnClick{
//    [self.videoPlayView jp_pause];
//}


- (void)dealloc {
    if (self.backScrollView.subviews[0] && [self.result safeIntForKey:@"type"] == 1) {
        [self.backScrollView.subviews[0] jp_stopPlay];
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
//            self.seeTimeBtn.enabled = NO;
            self.seeTimeBtn.hidden = YES;
        }else{
             self.redbagPackageView.hidden = YES;
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
    
}

//- (BOOL)shouldAutoReplayForURL:(nonnull NSURL *)videoURL{
//    return NO;
//}


@end
