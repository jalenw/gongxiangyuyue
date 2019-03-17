//
//  ServiceForUser.m
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import "ServiceForUser.h"
#import<CommonCrypto/CommonDigest.h>
@implementation ServiceForUser
+ (id)manager
{
    static dispatch_once_t predicate = 0;
    static ServiceForUser *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init] ;
    });
    return manager ;
}

-(void)postMethodName:(NSString*)name params:(NSDictionary*)params block:(GetRequestBlock)block
{
    NSMutableDictionary *param = [HTTPClientInstance newDefaultParameters];
    if (params!=nil) {
        [param addEntriesFromDictionary:params];
    }
    
    [HTTPClientInstance POST:[NSString stringWithFormat:@"%@",name] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        //zyf未登录跳转登录界面
//        if([dict safeStringForKey:@"message"],[dict safeIntForKey:@"code"]==100){//未登录状态
//            [AppDelegateInstance logout];
//        }
        block(dict,[dict safeStringForKey:@"message"],[dict safeIntForKey:@"code"]==200?YES:NO,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,nil,NO,error);
    }];
}

-(void)getMethodName:(NSString*)name params:(NSDictionary*)params block:(GetRequestBlock)block
{
    NSMutableDictionary *param = [HTTPClientInstance newDefaultParameters];
    if (params!=nil) {
        [param addEntriesFromDictionary:params];
    }
    
    [HTTPClientInstance GET:[NSString stringWithFormat:@"%@",name] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        block(dict,[dict safeStringForKey:@"message"],[dict safeIntForKey:@"code"]==200?YES:NO,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,nil,NO,error);
    }];
}


- (NSURLSessionDataTask*)postFileWithActionOp:(NSString*)actOpName andData:(NSData*)fileData andUploadFileName:(NSString*)fileName andUploadKeyName:(NSString*)keyName and:(NSString*)ext params:(NSDictionary*)params progress:( void (^)(NSProgress * ))uploadProgress block:(GetRequestBlock)resultBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",actOpName];
    
    NSMutableDictionary *requestDict = [HTTPClientInstance newDefaultParameters];
    if (params!=nil) {
        [requestDict addEntriesFromDictionary:params];
        
    }
    
    NSURLSessionDataTask *task = [HTTPClientInstance POST:urlString parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        
        NSInputStream *inputStream = [NSInputStream inputStreamWithData:fileData];
        [formData appendPartWithInputStream:inputStream name:keyName fileName:fileName length:fileData.length mimeType:ext];
        
        //[formData appendPartWithFileData:fileData name:keyName fileName:fileName mimeType:ext];
        //[formData appendPartWithFormData:fileData name:keyName];
        
        
    } progress:uploadProgress success:^(NSURLSessionDataTask *  task, id   responseObject) {
        NSDictionary *dict = responseObject;
        resultBlock(dict,[dict safeStringForKey:@"err_msg"],[dict safeIntForKey:@"err_code"]==0?YES:NO,nil);
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        resultBlock(nil,nil,0,error);
    }];
    
    return task;
    
}

@end
