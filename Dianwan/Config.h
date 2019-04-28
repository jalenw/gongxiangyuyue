//
//  Config.h
//  happy
//
//  Created by noodle on 16/9/12.
//  Copyright © 2016年 intexh. All rights reserved.
//

#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define ScreenBounds                    [UIScreen mainScreen].bounds
#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width

#define DefaultFontOfSize(s)    [UIFont systemFontOfSize:s]

#define ThemeColor RGB(255,123,58)

#define GrayColor1 RGB(244,244,244)
#define GrayColor2 RGB(154,154,154)

#define DarkColor1 RGB(11,11,11)
#define DarkColor2 RGB(50,50,50)

#define key_easemob [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_easemob"]//环信key
#define key_jpush  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_jpush"] //极光推送key
#define key_ShareSDK [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_ShareSDK"]//ShareSDK key
#define key_wechat_appid [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_wechat_appid"] //微信key
#define key_wechat_secret [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_wechat_secret"] //微信secret
#define key_weibo [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_weibo"] //微博key
#define key_weibo_secret [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_weibo_secret"] //微博secret
#define key_qq_appid [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_qq_appid"] //qq key
#define key_qq_appkey [[[NSBundle mainBundle] infoDictionary] objectForKey:@"key_qq_appkey"] //qq Appkey

#define H5_prefix [[[NSBundle mainBundle] infoDictionary] objectForKey:@"H5_prefix"] //原生H5交互对应的前缀
#define URL_SCHEME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"URL_SCHEME"] //APP URL



//判断iPhoneX、Xs
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//关闭键盘
#define HIDE_KEY_BOARD  [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  [Tooles currentViewController].navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
