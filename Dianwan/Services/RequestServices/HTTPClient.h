//
//  HTTPClient.h
//  Miju
//
//  Created by Roger on 12/9/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import "AFNetworking.h"
#define HTTPClientInstance [HTTPClient instance]
@interface HTTPClient : AFHTTPSessionManager
@property NSString* token;
@property NSString* uid;
+ (instancetype)instance;
- (NSMutableDictionary*)newDefaultParameters;
- (void)saveToken:(NSString*)token uid:(NSString*)uid;
- (BOOL)isLogin;
- (void)saveLoginData;
- (void)clearLoginData;
@end
