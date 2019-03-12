//
//  User.h
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserPicObject : NSObject

@end

@interface User : NSManagedObject

+ (NSArray*)insertWithArray:(NSArray*)array context:(NSManagedObjectContext*)context;
+ (instancetype)insertOrReplaceWithDictionary:(NSDictionary*)dict context:(NSManagedObjectContext*)context;
+ (instancetype)getObjectById:(long long)id context:(NSManagedObjectContext*)context;
@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
