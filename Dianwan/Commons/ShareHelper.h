//
//  ShareHelper.h
//  zingchat
//
//  Created by intexh on 15/7/1.
//  Copyright (c) 2015年 Miju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "ShareCommonView.h"

@interface ShareHelper : NSObject


+ (void)shareWithTitle:(NSString*)shareTitle content:(NSString*)shareContent images:(NSArray*)images description:(NSString*)shareDescription url:(NSString*)shareUrl shareType:(SSDKPlatformType)shareType result:(SSDKShareStateChangedHandler)result;

+ (void)showShareFailHintWithError:(NSError*)error;

+ (void)showShareCommonViewWithTitle:(NSString *)shareTitle content:(NSString *)shareContent images:(NSArray *)images description:(NSString *)shareDescription url:(NSString *)shareUrl andViewTitle:(NSString*)viewTitle andViewDes:(NSString*)viewDes result:(SSDKShareStateChangedHandler)result block:(ShareCommonViewBlock)block;

@end
