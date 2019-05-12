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
//去指定页面
-(void)goPage:(NSString*)index;
//跳转我要开播
-(void)createLiveRoom;
//跳转已购课程
-(void)toBuySubject;
//支付
-(void)pay:(NSString* )type :(NSString *)from :(NSString *)price :(NSString *)json;

//购买金币
-(void)buyGold:(NSString*)t_id :(NSString*)price;

//约家订单支付
-(void)yuePay:(NSString*)orderId :(NSString*)price;

//钱包提现
-(void)withDrawal:(NSString *)json;

//第三方支付充值
-(void)resetPay:(NSString*)sn :(NSString*)payment_code;

//加好友
-(void)addFriend:(NSString* )chartId :(NSString *)avatar :(NSString *)userName;

-(void)uploadImg;

- (IBAction)closePwView:(UIButton *)sender;
@end
