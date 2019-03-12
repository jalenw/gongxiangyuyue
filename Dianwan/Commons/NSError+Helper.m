//
//  NSError+Helper.m
//  Ekeo2
//
//  Created by Roger on 13-8-29.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import "NSError+Helper.h"
#import "AFNetworking.h"

@implementation NSError (Helper)

- (NSString*)localizedRecoverySuggestionInfo
{
    if ([self.domain isEqualToString:NSURLErrorDomain])
    {
        return @"网络异常";
    }
    
    do
    {
        NSString *recoverySuggestion = [self.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
        //2014 12 19 bigin edit by liujun 未改动，只是注释掉了
        //        if (!recoverySuggestion)
        //        {
        //            break;
        //        }
        //2014 12 19 end edit by liujun
        return recoverySuggestion;
        
//        NSData *data = [recoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        
//        NSString* info = [dic objectForKey:@"info"];
//        if (!info)
//        {
//            break;
//        }
//        
//        return info;
    }while (false);
    //2014 12 04 bigin edit by liujun

    return nil;//release模式返回nil进行判断是否弹出警告框
    //2014 12 04 end edit by liujun

    
}

- (NSDictionary *)localizedRecoverySuggestionInfoData
{
//    if ([self.domain isEqualToString:NSURLErrorDomain])
//    {
////        return S_NetworkError;
//    }
//    
//    do
//    {
        NSDictionary *recoverySuggestion = [self.userInfo objectForKey:@"NSLocalizedRecoverySuggestionData"];
        return recoverySuggestion;
//    }while (false);
}


@end
