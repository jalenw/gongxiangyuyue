//
//  PayViewController.m
//  ShopFun
//
//  Created by noodle on 16/5/17.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "PayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SetPayPwViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    self.payTypeView.layer.cornerRadius = 5;
    self.payTypeView.layer.masksToBounds = YES;
    self.payView.layer.cornerRadius = 5;
    self.payView.layer.masksToBounds = YES;
    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.borderWidth = 1;
    self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderWidth = 1;
    self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.height = ScreenHeight;
    self.view.width = ScreenWidth;
}

- (IBAction)aliPayAct:(UIButton *)sender {
    NSMutableDictionary* Params = [HTTPClientInstance newDefaultParameters];
    [Params setValue:self.pay_sn forKey:@"pay_sn"];
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"" params:Params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed){
        [SVProgressHUD dismiss];
        if (status) {
           [self ali:[[data safeDictionaryForKey:@"datas"] safeStringForKey:@"signStr"]];
        }
    }];
}

- (void)ali:(NSString*)signStr{
    NSString *appScheme = URL_SCHEME;
    [[AlipaySDK defaultService] payOrder:signStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        long long errorCode = [resultDic safeLongLongForKey:@"resultStatus"];
        if (errorCode == 9000) {
            [AlertHelper showAlertWithTitle:@"支付成功"];
            self.block();
            [self closeViewAct:nil];
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

- (IBAction)wechatPayAct:(UIButton *)sender {
    if (![WXApi isWXAppInstalled]) {
        [AlertHelper showAlertWithTitle:@"未安装微信"];
        return;
    }
     [WXApiManager sharedManager].delegate = self;
    NSMutableDictionary* Params = [HTTPClientInstance newDefaultParameters];
    [Params setValue:self.pay_sn forKey:@"pay_sn"];
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"" params:Params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed){
        [SVProgressHUD dismiss];
        if (status) {
            NSDictionary *dict = [data safeDictionaryForKey:@"datas"];
            dict = [dict safeDictionaryForKey:@"sgin_info"];
            PayReq *payReq = [[PayReq alloc] init];
            payReq.partnerId = [dict safeStringForKey:@"partnerid"];
            payReq.prepayId= [dict safeStringForKey:@"prepayid"];
            payReq.package = [dict safeStringForKey:@"package"];
            payReq.nonceStr= [dict safeStringForKey:@"noncestr"];
            long long stamp  = [[dict safeStringForKey:@"timestamp"] longLongValue];
            payReq.timeStamp= (UInt32)stamp;
            
            payReq.sign= [dict safeStringForKey:@"sign"];
            BOOL isSuccess = [WXApi sendReq:payReq];
            if (isSuccess == NO) {
                [AlertHelper showAlertWithTitle:@"微信支付调用失败"];
            }
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (IBAction)closeViewAct:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)showPayView:(UIButton *)sender {
    [SVProgressHUD show];
    [[ServiceForUser manager]postMethodName:@"" params:@{} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        [SVProgressHUD dismiss];
        if (status) {
            if ([[data safeDictionaryForKey:@"datas"]safeIntForKey:@"type"]==1) {
                SetPayPwViewController*vc = [[SetPayPwViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                self.payView.hidden = NO;
                self.payTypeView.hidden = YES;
            }
        }
        else [AlertHelper showAlertWithTitle:error];
    }];
}

- (IBAction)closePayView:(UIButton *)sender {
                self.payView.hidden = YES;
                self.payTypeView.hidden = NO;
}

//使用钱包支付
- (IBAction)payAct:(UIButton *)sender {
    NSMutableDictionary* Params = [HTTPClientInstance newDefaultParameters];
    [Params setValue:self.pay_sn forKey:@"pay_sn"];
    [Params setValue:self.password.text forKey:@"member_paypwd"];
    [SVProgressHUD show];
    [[ServiceForUser manager] postMethodName:@"" params:Params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed){
        [SVProgressHUD dismiss];
        if (status) {
            [AlertHelper showAlertWithTitle:@"支付成功"];
            self.block();
            [self closeViewAct:nil];
        }
        else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
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
        //NSLog(@"支付成功");
        [AlertHelper showAlertWithTitle:@"支付成功"];
    }else{
        //NSLog(@"支付失败，retcode=%d",response.errCode);
        if (response.errStr) {
            [AlertHelper showAlertWithTitle:response.errStr];
        }else{
            [AlertHelper showAlertWithTitle:@"支付失败"];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
