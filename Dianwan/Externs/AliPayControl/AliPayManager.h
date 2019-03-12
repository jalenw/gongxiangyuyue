//
//  AliPayManager.h
//  kuxing
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AliPayManagerDelegate <NSObject>

@optional



- (void)aliManagerDidRecvPayResponse:(NSDictionary *)resultDic;

@end

@interface AliPayManager : NSObject

@property (nonatomic, assign) id<AliPayManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
