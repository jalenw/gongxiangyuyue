//
//  HTTPClient.m
//  Miju
//
//  Created by Roger on 12/9/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import "HTTPClient.h"

static HTTPClient *_instance = nil;
@interface HTTPClient ()
@end

@implementation HTTPClient

+ (instancetype)instance
{
    if (!_instance)
    {
        _instance = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:base_url]]];
        _instance.responseSerializer = [AFJSONResponseSerializer serializer];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
        [_instance readLoginData];
    }
    return _instance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
    }
    
    return self;
}

- (NSMutableDictionary*)newDefaultParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.token != nil) {
        [parameters setObject:self.token forKey:@"key"];
    }
    else
    {
        [self readLoginData];
        if (self.token!=nil) {
            [parameters setObject:self.token forKey:@"key"];
        }
        else [parameters setObject:@"" forKey:@"key"];
    }
    return parameters;
}

- (BOOL)isLogin
{
    return self.token;
}

- (void)saveToken:(NSString*)token uid:(NSString*)uid
{
    self.token = [NSString stringWithString:token];
    self.uid = [NSString stringWithFormat:@"%@",uid];
    [self saveLoginData];
}

- (void)readLoginData
{
    NSString* login_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLoginToken"];
    if (login_token.length > 0)
    {
        NSArray* array = [login_token componentsSeparatedByString:@"__"];
        if (array.count >= 2)
        {
            [self saveToken:[array objectAtIndex:0] uid:[array objectAtIndex:1]];
        }
    }
}

- (void)saveLoginData
{
    NSString* login_token = [NSString stringWithFormat:@"%@__%@", self.token,self.uid];
    [[NSUserDefaults standardUserDefaults] setObject:login_token forKey:@"kLoginToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearLoginData
{
    self.token = nil;
    self.uid = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kLoginToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
