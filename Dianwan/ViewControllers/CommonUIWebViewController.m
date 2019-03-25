//
//  CommonUIViewController.m
//  kuxing
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CommonUIWebViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "ShareHelper.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LZHAlertView.h"

#import "LZHActionSheetView.h"
#import "AliPayManager.h"

#import "UINavigationItem+SXFixSpace.h"

#import "ChatViewController.h"

#import "PayViewController.h"

#import "WaitPayViewController.h"

#import "ClassDetailViewController.h"


#import "SYPasswordView.h"

@protocol JSBridgeExport <JSExport>
//与H5交互协议

- (void)back;

//前往支付页面
-(void)toPay:(NSInteger )type :(NSString *)from :(NSString *)price :(NSString *)json;

-(void)yuePay:(NSString*)orderId :(NSString*)price;

//钱包提现
-(void)withDrawal:(NSString *)json;

-(void)resetPay:(NSString*)sn :(NSString*)payment_code;

-(void)goPage;

- (void)tochat:(NSString*)toUserId :(NSString*)toUserNickName :(NSString*)toUserAvatar :(NSString*)toUserChatId;

-(void)toClassDetail:(NSString*)goodId;

- (void)share:(NSString*)shareImage :(NSString*)shareTitle :(NSString*)shareContent :(NSString*)shareUrl ;

- (void)home;

- (void)withdrawal:(NSString*)pay_style :(NSString*)price;

- (void)pay_style:(NSString*)pay_sn;
@end

@interface JSBridge : NSObject <JSBridgeExport>

@property (nonatomic, weak) CommonUIWebViewController *webViewController;

@end
@implementation JSBridge

//与H5交互协议具体方法

//- (void)go2Chat:(NSString *)member_chat_id :(NSString *)member_id :(NSString*)member_name :(NSString*)member_avatar{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.webViewController go2Chat:member_chat_id :member_id :member_name :member_avatar];
//    });
//}

- (void)tochat:(NSString*)toUserId :(NSString*)toUserNickName :(NSString*)toUserAvatar :(NSString*)toUserChatId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController tochat:toUserId :toUserNickName :toUserAvatar :toUserChatId];
    });
}

-(void)toClassDetail:(NSString*)goodId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController toClassDetail:goodId];
    });
}

- (void)back{
    [self.webViewController performSelectorOnMainThread:@selector(back) withObject:nil waitUntilDone:NO];
}


-(void)withDrawal:(NSString *)json{
      dispatch_async(dispatch_get_main_queue(), ^{
          [self.webViewController withDrawal:json];
      });
}


-(void)goPage{
     [self.webViewController performSelectorOnMainThread:@selector(goPage) withObject:nil waitUntilDone:NO];
}



-(void)toPay:(NSInteger )type :(NSString *)frome :(NSString *)price :(NSString *)json{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController toPay:type :frome :price :json];
    });
}

-(void)yuePay:(NSString*)orderId :(NSString*)price
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController yuePay:orderId :price];
    });
}

-(void)resetPay:(NSString*)sn :(NSString*)payment_code
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController resetPay:sn :payment_code];
    });
}

- (void)share:(NSString*)shareImage :(NSString*)shareTitle :(NSString*)shareContent :(NSString*)shareUrl {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController share:shareImage :shareTitle :shareContent :shareUrl];
    });
}

- (void)home
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController home];
    });
}

- (void)withdrawal:(NSString*)pay_style :(NSString*)price
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController withdrawal:pay_style :price];
    });
}

- (void)pay_style:(NSString*)pay_sn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webViewController pay_style:pay_sn];
    });
}
@end

@interface CommonUIWebViewController ()<UITextFieldDelegate,AliPayManagerDelegate,WXApiManagerDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) JSContext *jsContext;
@property (strong, nonatomic) IBOutlet UIView *pwInputView;
@property (weak, nonatomic) IBOutlet UIView *pwView;

@property (nonatomic, strong) SYPasswordView *pasView;
@end

@implementation CommonUIWebViewController

- (void)dealloc{
    _webView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.topic) {
        self.title = self.topic;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpace.width = -10;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 34, 44)];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItems = @[leftSpace,backBarItem];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:webView];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.scrollView.bounces = NO;
    webView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;

    if (self.H5Content.length > 0) {
        [webView loadHTMLString:self.H5Content baseURL:nil];
    }else{
        if ([self.address hasPrefix:@"http"] == NO) {
            self.address = [NSString stringWithFormat:@"http://%@",self.address];
        }
        if ([self.address containsString:@"?"]) {
            self.address = [self addUrlDefaultParam:self.address];
        }
        
        NSURL *url = [NSURL URLWithString:self.address];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
        [webView loadRequest:request];
    }
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.hidden = YES;
    self.backButton = backButton;
    
    self.pwInputView.frame = self.view.bounds;
    self.pwInputView.hidden = YES;
    [self.view addSubview:self.pwInputView];
}

//若果地址参数没有带key，自动补全
- (NSString*)addUrlDefaultParam:(NSString*)urlString{
    
    NSString *oUrl = urlString;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:[Tooles getDictFromUrlString:oUrl]];
    if (HTTPClientInstance.token.length > 0) {
        param[@"key"] = HTTPClientInstance.token;
        
    }else{
        [param removeObjectForKey:@"key"];
    }
    NSString *paramString = [Tooles getUrlStringParamFromDict:param];
    NSString *nUrl = [[oUrl componentsSeparatedByString:@"?"] firstObject];
    nUrl = [NSString stringWithFormat:@"%@?%@",nUrl,paramString];
    
    return nUrl;
    
}

- (void)reloadWebview{
    [self.webView reload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.showNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.showNav) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)share:(NSString*)shareImage :(NSString*)shareTitle :(NSString*)shareContent :(NSString*)shareUrl {
    NSArray *images = nil;
    if (shareImage.length > 0) {
        images = @[shareImage];
    }
    NSMutableDictionary *dict = [Tooles getDictFromUrlString:shareUrl].mutableCopy;
    [ShareHelper showShareCommonViewWithTitle:shareTitle content:shareContent images:images description:@"" url:shareUrl andViewTitle:shareTitle andViewDes:shareContent result:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [AlertHelper showAlertWithTitle:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                [ShareHelper showShareFailHintWithError:error];
                break;
            }
            default:
                break;
        }
    } block:^(NSInteger index) {
    }];
}

- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)withdrawal:(NSString*)pay_style :(NSString*)price
{
    if ([pay_style isEqualToString:@"ali_pay"]) {
        [AliPayManager sharedManager].delegate = self;
        NSDictionary *param = @{@"price":price};
        [SVProgressHUD show];
        [[ServiceForUser manager] postMethodName:@"" params:param block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            [SVProgressHUD dismiss];
            if (status) {
                NSDictionary *dict = [data safeDictionaryForKey:@"datas"];
                NSString *signStr = [dict safeStringForKey:@"signStr"];
                NSString *appScheme = URL_SCHEME;
                [[AlipaySDK defaultService] payOrder:signStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    long long errorCode = [resultDic safeLongLongForKey:@"resultStatus"];
                    if (errorCode == 9000) {
                        [AlertHelper showAlertWithTitle:@"支付成功"];
                        [self reloadWebview];
                    }else{
                        if (errorCode == 6001){
                            [AlertHelper showAlertWithTitle:@"支付失败"];
                        }else{
                            NSString *errorString = [resultDic safeStringForKey:@"memo"];
                            [AlertHelper showAlertWithTitle:errorString];
                        }
                    }
                }];
            }else{
                [AlertHelper showAlertWithTitle:error];
            }
        }];
    }
    if ([pay_style isEqualToString:@"weChat_pay"]) {
        if (![WXApi isWXAppInstalled]) {
            [AlertHelper showAlertWithTitle:@"未安装微信"];
            return;
        }
        [WXApiManager sharedManager].delegate = self;
        NSDictionary *param = @{@"price":price};
        [SVProgressHUD show];
        [[ServiceForUser manager] postMethodName:@"" params:param block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
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
}

- (void)pay_style:(NSString*)pay_sn
{
    PayViewController *payViewController = [[PayViewController alloc]init];
    [self addChildViewController:payViewController];
    payViewController.pay_sn = pay_sn;
    [payViewController setBlock:^{
        [self reloadWebview];
    }];
    [self.view addSubview:payViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = theTitle;

    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSBridge *jsBridge = [[JSBridge alloc] init];
    self.jsContext[H5_prefix] = jsBridge;//对应H5的前缀
    jsBridge.webViewController = self;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)back{
        if (self.webView.canGoBack) {
            [self.webView goBack];
        }else{
            [self dismissWebView];
        }
}

-(void)withDrawal:(NSString *)json{
    
    
    self.pwInputView.hidden = NO;
    [self.pasView.textField becomeFirstResponder];
    //创建密码输入控价
    self.pasView.layer.cornerRadius = 5;
    self.pasView.layer.masksToBounds =YES;
    [self.pwView addSubview:_pasView];
    __weak typeof(self) weakSelf = self;
    self.pasView.inputAllBlodk = ^(NSString *pwNumber) {
        //支付操作
        [weakSelf.pasView clearUpPassword];
        [weakSelf.pasView.textField resignFirstResponder];
        weakSelf.pwInputView.hidden = YES;
        [SVProgressHUD dismiss];
        NSDictionary *requeatParams =  [Tooles stringToJson:json];
        NSDictionary *params =@{
                                @"pdc_amount":[requeatParams safeStringForKey:@"pdc_amount"],
                                @"pdc_bank_name":[requeatParams safeStringForKey:@"pdc_bank_name"],
                                @"pdc_bank_no":[requeatParams safeStringForKey:@"pdc_bank_no"],
                                @"pdc_bank_user":[requeatParams safeStringForKey:@"pdc_bank_user"],
                                @"mobilenum":@([requeatParams safeIntForKey:@"mobilenum"]),
                                @"password":pwNumber
                                };
        [[ServiceForUser manager] postMethodName:@"Recharge/pd_cash_add.html" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
            if (status) {
                 weakSelf.pwInputView.hidden = YES;
            }else{
                [AlertHelper showAlertWithTitle:error];
                weakSelf.pwInputView.hidden = YES;
            }
        }];
        
    };
        
 
}




-(void)goPage{
    [self dismissWebView];
}

- (void)dismissWebView{
    
    if (self.presentingViewController) {
        UIViewController *rootController = [self.navigationController.viewControllers firstObject];
        if (rootController == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)cancelDidTap:(UIButton*)button{
    [self dismissWebView];
}

- (void)aliManagerDidRecvPayResponse:(NSDictionary *)resultDic{
    long long errorCode = [resultDic safeLongLongForKey:@"resultStatus"];
    if (errorCode == 9000) {
        [AlertHelper showAlertWithTitle:@"支付成功"];
    }else{
        if (errorCode == 6001){
            [AlertHelper showAlertWithTitle:@"支付失败"];
        }else{
            NSString *errorString = [resultDic safeStringForKey:@"memo"];
            [AlertHelper showAlertWithTitle:errorString];
        }
    }
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

- (void)tochat:(NSString*)toUserId :(NSString*)toUserNickName :(NSString*)toUserAvatar :(NSString*)toUserChatId
{
    if (HTTPClientInstance.isLogin == NO) {
        [AlertHelper showAlertWithTitle:@"请登录后再进行操作"];
        return;
    }
    if (toUserChatId.length > 0) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:toUserChatId conversationType:eConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        [AlertHelper showAlertWithTitle:@"聊天信息有误"];
        return;
    }
}

-(void)toClassDetail:(NSString*)goodId
{
    ClassDetailViewController *vc = [[ClassDetailViewController alloc]init];
    vc.classId = goodId;
    [self.navigationController pushViewController:vc animated:YES];
}

//vip支付
-(void)toPay:(NSInteger )type :(NSString *)from :(NSString *)price :(NSString *)json;
{
    WaitPayViewController *waitpay = [[WaitPayViewController alloc]init];
    waitpay.moneryNum =price;
    waitpay.order_id =@"";
    waitpay.json = json;
    waitpay.type = [NSString stringWithFormat:@"%ld",(long)type];
    [self.navigationController pushViewController:waitpay animated:YES];
    
}

-(void)yuePay:(NSString*)orderId :(NSString*)price
{
    
}

-(void)resetPay:(NSString*)sn :(NSString*)payment_code
{
    NSString *code = @"";
    if ([payment_code isEqualToString:@"1"]) {
        code = @"alipay_app";
    }
    else if ([payment_code isEqualToString:@"2"]) {
        code = @"wxpay_app";
    }
    [[ServiceForUser manager] postMethodName:@"index.php?s=mobile/Memberpayment/pd_pay" params:@{@"pay_sn":sn,@"payment_code":code} block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
}

- (SYPasswordView *)pasView{
    if (!_pasView) {
        _pasView =  [[SYPasswordView alloc] initWithFrame:CGRectMake(20, 93, 288, 48)];
    }
    return _pasView;
}
@end
