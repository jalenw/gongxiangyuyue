//
//  ShareHelper.m
//  zingchat
//
//  Created by intexh on 15/7/1.
//  Copyright (c) 2015年 Miju. All rights reserved.
//

#import "ShareHelper.h"
#import <MessageUI/MessageUI.h>

@implementation ShareHelper

+ (void)shareWithTitle:(NSString*)shareTitle content:(NSString*)shareContent images:(NSArray*)images description:(NSString*)shareDescription url:(NSString*)shareUrl shareType:(SSDKPlatformType)shareType result:(SSDKShareStateChangedHandler)result{
    if (shareTitle == nil) {
        shareTitle = @"";
    }
    if (shareContent == nil) {
        shareContent = @"";
    }
    if (shareUrl == nil) {
        shareUrl = @"";
    }
    if (shareDescription == nil) {
        shareDescription = @"";
    }
    if (images == nil || images.count == 0) {
        //images = @[@"http://i.zingchat.cn/logo.png"];
    }
    
    NSMutableDictionary *shareParam = [NSMutableDictionary dictionary];
    [shareParam SSDKSetupShareParamsByText:shareContent images:images url:[NSURL URLWithString:shareUrl] title:shareTitle type:SSDKContentTypeAuto];
    
    [ShareSDK share:shareType parameters:shareParam onStateChanged:result];
}

+ (void)showShareFailHintWithError:(NSError*)error{
//    if (error.code == -6004) {
//        [AlertHelper showAlertWithTitle:@"温馨提示" message:@"尚未安装QQ客户端，请安装后重试！"];
//    }else if (error.code == -22005) {
//    }else{
//        [AlertHelper showErrorAlert:error];
//    }
    NSString *errorMessage = error.userInfo[@"error_message"];
    if (errorMessage == nil) {
        errorMessage = @"授权失败";
    }
    [AlertHelper showAlertWithTitle:errorMessage];

}


+ (void)showShareCommonViewWithTitle:(NSString *)shareTitle content:(NSString *)shareContent images:(NSArray *)images description:(NSString *)shareDescription url:(NSString *)shareUrl andViewTitle:(NSString*)viewTitle andViewDes:(NSString*)viewDes result:(SSDKShareStateChangedHandler)result block:(ShareCommonViewBlock)block{
    if (shareTitle == nil) {
        shareTitle = @"";
    }
    if (shareContent == nil) {
        shareContent = @"";
    }
    if (shareUrl == nil) {
        shareUrl = @"";
    }
    if (shareDescription == nil) {
        shareDescription = @"";
    }
    if (images == nil || images.count == 0) {
        //images = @[[UIImage imageNamed:@"appIcon128"]];
    }
    if (viewTitle == nil) {
        viewTitle = @"";
    }
    if (viewDes == nil) {
        viewDes = @"";
    }
    
    if(shareTitle.length > 18){
        shareTitle = [shareTitle substringWithRange:NSMakeRange(0, 18)];
    }
    if(shareContent.length > 100){
        shareContent = [shareContent substringWithRange:NSMakeRange(0, 100)];
    }
    
    NSMutableDictionary *shareParam = [NSMutableDictionary dictionary];
    [shareParam SSDKSetupShareParamsByText:shareContent images:images url:[NSURL URLWithString:shareUrl] title:shareTitle type:SSDKContentTypeAuto];
    
    ShareCommonView *shareView = [[ShareCommonView alloc] initWithFrame:ScreenBounds];
    shareView.shareParam = shareParam;
    shareView.shareBlock = result;
    shareView.block = block;
    [AppDelegateInstance.window addSubview:shareView];
}

@end
