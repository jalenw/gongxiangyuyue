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
#import "LivePlayerViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "AliPayManager.h"
@interface WaitPayViewController () <WXApiManagerDelegate>
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
    if (self.type==3) {
        self.typeLb.text = @"金币支付";
    }
    if (self.payType==2) {
        self.typeLb.text = @"金币支付";
    }
    if (self.type==7) {
        self.aliView.hidden = NO;
        self.wechatView.hidden = NO;
    }
    //创建密码输入控价
    self.pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(20, 93, 288, 48)];
    //zyf
    self.pasView.layer.cornerRadius = 5;
    self.pasView.layer.masksToBounds =YES;
      __weak typeof(self) weakSelf = self;
    self.pasView.inputAllBlodk = ^(NSString *pwNumber) {
        if (weakSelf.type==1) {
            [weakSelf payForMine:pwNumber];
        }
        if (weakSelf.type==2) {
            [weakSelf payForClass:pwNumber];
        }
        if (weakSelf.type==3) {
            [weakSelf payForVideo:pwNumber];
        }
        if (weakSelf.type==4) {
            [weakSelf payForLive:pwNumber];
        }
        if (weakSelf.type==5) {
            
        }
        if (weakSelf.type==6) {
            [weakSelf payForGoodsWithGold:pwNumber];
        }
        if (weakSelf.type==7) {
            [weakSelf payForGoods:pwNumber];
        }
    };
    [self.pwView addSubview:_pasView];
    self.pwInputView.frame = ScreenBounds;
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
//    if([self.pay_type isEqualToString:@"alipay_app"] ||[self.pay_type isEqualToString:@"wxpay_app"]  ){
//        [AlertHelper showAlertWithTitle:@"功能暂未开通"];
//    }else{
        self.pwInputView.hidden = NO;
        [self.pasView.textField becomeFirstResponder];
//    }
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

-(void)payForVideo:(NSString*)pwNumber
{
    NSDictionary *params=@{
                           @"id":self.order_id,
                           @"member_paypwd":pwNumber
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"storevideo/pay_video" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshVideoList" object:nil];
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            paysuc.btText = @"查看购买视频";
            [paysuc setBlock:^{
                MPMoviePlayerViewController *mPMoviePlayerViewController;
                mPMoviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[self.dict safeStringForKey:@"video_url"]]];
                mPMoviePlayerViewController.view.frame = ScreenBounds;
                [self presentViewController:mPMoviePlayerViewController animated:YES completion:nil];
            }];
            [self.navigationController pushViewController:paysuc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)payForLive:(NSString*)pwNumber
{
    NSDictionary *params=@{
                           @"chatroom_id":self.order_id,
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"channels/paymentChannelOrderInfo" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
    [SVProgressHUD dismiss];
        if (status) {
    NSDictionary *params=@{
                           @"order_sn":[data safeStringForKey:@"result"],
                           @"member_paypwd":pwNumber,
                           @"pay_type":self.pay_type
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"channels/payChannelsMemberOrder" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshLiveList" object:nil];
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            paysuc.btText = @"查看购买直播";
            [paysuc setBlock:^{
                LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
                vc.url = [self.dict safeStringForKey:@"play"];
                vc.dict = self.dict;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [self.navigationController pushViewController:paysuc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)payForGoodsWithGold:(NSString*)pwNumber
{
    NSDictionary *params=@{
                           @"pay_sn":[[Tooles stringToJson:self.json] safeStringForKey:@"pay_sn"],
                           @"password":pwNumber
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"memberpayment/goldlog" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
            paysuc.btText = @"查看购买订单";
            [paysuc setBlock:^{
                CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
                commonweb.address =[NSString stringWithFormat:@"%@wap/member/order_list.html?",web_url];
                commonweb.showNav = NO;
                [self.navigationController pushViewController:commonweb animated:YES];
            }];
            [self.navigationController pushViewController:paysuc animated:YES];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)payForGoods:(NSString*)pwNumber
{
    NSString *payment_code = @"";
    NSString *pd_pay = @"";
    if ([self.pay_type isEqualToString:@"money"]) {
        payment_code = @"alipay_app";
        pd_pay = @"1";
    }
    if ([self.pay_type isEqualToString:@"alipay_app"]) {
        payment_code = @"alipay_app";
        pd_pay = @"0";
    }
    if ([self.pay_type isEqualToString:@"wxpay_app"]) {
        payment_code = @"wxpay_app";
        pd_pay = @"0";
    }
    NSDictionary *params=@{
                           @"pd_pay":pd_pay,
                           @"order_sn":[[Tooles stringToJson:self.json] safeStringForKey:@"pay_sn"],
                           @"password":pwNumber,
                           @"payment_code":payment_code
                           };
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"memberpayment/pay_new" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [self.pasView clearUpPassword];
        [self.pasView.textField resignFirstResponder];
        self.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        if (status) {
            if ([self.pay_type isEqualToString:@"wxpay_app"]) {
                if (![WXApi isWXAppInstalled]) {
                    [AlertHelper showAlertWithTitle:@"未安装微信"];
                    return;
                }
                [WXApiManager sharedManager].delegate = self;
                NSDictionary *dict = [data safeDictionaryForKey:@"result"];
                PayReq *payReq = [[PayReq alloc] init];
                payReq.partnerId = [dict safeStringForKey:@"partner_id"];
                payReq.prepayId= [dict safeStringForKey:@"prepay_id"];
                payReq.package = [dict safeStringForKey:@"package"];
                payReq.nonceStr= [dict safeStringForKey:@"nonce_str"];
                long long stamp  = [[dict safeStringForKey:@"timestamp"] longLongValue];
                payReq.timeStamp= (UInt32)stamp;
                payReq.sign= [dict safeStringForKey:@"sign"];
                BOOL isSuccess = [WXApi sendReq:payReq];
                if (isSuccess == NO) {
                    [AlertHelper showAlertWithTitle:@"微信支付调用失败"];
                }
            }
            else if ([self.pay_type isEqualToString:@"alipay_app"]) {
                NSDictionary *dict = [data safeDictionaryForKey:@"result"];
                NSString *signStr = [dict safeStringForKey:@"content"];
                NSString *appScheme = URL_SCHEME;
                [[AlipaySDK defaultService] payOrder:signStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    long long errorCode = [resultDic safeLongLongForKey:@"resultStatus"];
                    if (errorCode == 9000) {
                        [AlertHelper showAlertWithTitle:@"支付成功"];
                        [self checkOrderList];
                    }else{
                        if (errorCode == 6001){
                            [AlertHelper showAlertWithTitle:@"支付失败"];
                        }else{
                            NSString *errorString = [resultDic safeStringForKey:@"memo"];
                            [AlertHelper showAlertWithTitle:errorString];
                        }
                    }
                }];
            }
            else
            {
                [self checkOrderList];
            }
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

-(void)checkOrderList
{
    PaySucessViewController *paysuc = [[PaySucessViewController alloc]init];
    paysuc.btText = @"查看购买订单";
    [paysuc setBlock:^{
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/order_list.html?",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }];
    [self.navigationController pushViewController:paysuc animated:YES];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = nil;
    
    if ([msg.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
        WXAppExtendObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n附带信息：%@ \n文件大小:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)obj.fileData.length, msg.messageExt];
    }
    else if ([msg.mediaObject isKindOfClass:[WXTextObject class]]) {
        WXTextObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n内容：%@\n", req.openID, msg.title, msg.description, obj.contentText];
    }
    else if ([msg.mediaObject isKindOfClass:[WXImageObject class]]) {
        WXImageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n图片大小:%lu bytes\n", req.openID, msg.title, msg.description, (unsigned long)obj.imageData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXLocationObject class]]) {
        WXLocationObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n经纬度：lng:%f_lat:%f\n", req.openID, msg.title, msg.description, obj.lng, obj.lat];
    }
    else if ([msg.mediaObject isKindOfClass:[WXFileObject class]]) {
        WXFileObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n文件类型：%@ 文件大小:%lu\n", req.openID, msg.title, msg.description, obj.fileExtension, (unsigned long)obj.fileData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXWebpageObject class]]) {
        WXWebpageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n网页地址：%@\n", req.openID, msg.title, msg.description, obj.webpageUrl];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //从微信启动App
    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp"
                                                    message:cardStr
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvPayResponse:(PayResp *)response{
    if (response.errCode == 0) {
        //服务器端查询支付通知或查询API返回的结果再提示成功
        [AlertHelper showAlertWithTitle:@"支付成功"];
        [self checkOrderList];
    }else{
        //NSLog(@"支付失败，retcode=%d",response.errCode);
        if (response.errStr) {
            [AlertHelper showAlertWithTitle:response.errStr];
        }else{
            [AlertHelper showAlertWithTitle:@"支付失败"];
        }
    }
    
}
@end
