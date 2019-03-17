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
- (void)go2Chat:(NSString*)member_chat_id :(NSString*)member_id :(NSString*)member_name :(NSString*)member_avatar;

//消失WebView
- (void)dismissWebView;

//分享
- (void)share:(NSString*)shareImage :(NSString*)shareTitle :(NSString*)shareContent :(NSString*)shareUrl ;

//回到主页
- (void)home;

//vip支付
-(void)pay:(NSInteger )type from:(NSString *)frome price:(NSString *)price json:(NSString *)json;




//H5直接调用支付
- (void)withdrawal:(NSString*)pay_style :(NSString*)price;

//根据订单号打开选择支付方式，包含钱包支付
- (void)pay_style:(NSString*)pay_sn;
@end
