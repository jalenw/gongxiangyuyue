//
//  CommonUIViewController.h
//  kuxing
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonUIWebViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, strong) NSString *topic;//H5页面标题
@property (nonatomic, strong) NSString *address;//加载H5地址
@property (nonatomic, strong) NSString *H5Content;//直接加载HTML代码
@property (nonatomic,assign)BOOL showNav;//是否使用原生导航栏

//跳转聊天
- (void)tochat:(NSString*)toUserId :(NSString*)toUserNickName :(NSString*)toUserAvatar :(NSString*)toUserChatId;
//跳转课程详情
-(void)toClassDetail:(NSString*)goodId;
//消失WebView
- (void)dismissWebView;

//分享
- (void)share:(NSString*)shareImage :(NSString*)shareTitle :(NSString*)shareContent :(NSString*)shareUrl ;

//回到主页
- (void)home;

//vip支付
-(void)toPay:(NSInteger )type :(NSString *)from :(NSString *)price :(NSString *)json;

//约家订单支付
-(void)yuePay:(NSString*)orderId :(NSString*)price;

//钱包提现
-(void)withDrawal:(NSString *)json;

//第三方支付充值
-(void)resetPay:(NSString*)sn :(NSString*)payment_code;

//H5直接调用支付
- (void)withdrawal:(NSString*)pay_style :(NSString*)price;

//根据订单号打开选择支付方式，包含钱包支付
- (void)pay_style:(NSString*)pay_sn;
@end
