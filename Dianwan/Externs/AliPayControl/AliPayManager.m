//
//  AliPayManager.m
//  kuxing
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AliPayManager.h"

@implementation AliPayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AliPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AliPayManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
}

@end
