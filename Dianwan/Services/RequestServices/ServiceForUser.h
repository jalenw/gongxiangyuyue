//
//  ServiceForUser.h
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GetRequestBlock)(NSDictionary *data,NSString *error,BOOL status,NSError *requestFailed);
@interface ServiceForUser : NSObject
+ (id)manager;
//post请求方式
-(void)postMethodName:(NSString*)name params:(NSDictionary*)params block:(GetRequestBlock)block;
-(void)postMethodName2:(NSString*)name params:(NSDictionary*)params block:(GetRequestBlock)block;
//get请求方式
-(void)getMethodName:(NSString*)name params:(NSDictionary*)params block:(GetRequestBlock)block;
//上传文件
- (NSURLSessionDataTask*)postFileWithActionOp:(NSString*)actOpName andData:(NSData*)fileData andUploadFileName:(NSString*)fileName andUploadKeyName:(NSString*)keyName and:(NSString*)ext params:(NSDictionary*)params progress:( void (^)(NSProgress * ))uploadProgress block:(GetRequestBlock)resultBlock;
@end
