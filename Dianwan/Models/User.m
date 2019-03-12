//
//  User.m
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import "User.h"
#import "DBHelper.h"

@implementation UserPicObject

@end

@implementation User
+ (NSArray*)insertWithArray:(NSArray*)array context:(NSManagedObjectContext*)context
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *dict in array)
    {
        User *object = [User insertOrReplaceWithDictionary:dict context:context];
        if (object)
        {
            [result addObject:object];
        }
    }
    
    return result;
}


+ (instancetype)insertOrReplaceWithDictionary:(NSDictionary*)dict context:(NSManagedObjectContext*)context
{
    if (!dict)
    {
        return nil;
    }
    
    User *object = nil;
    if ([dict hasObjectForKey:@"userid"]) {
        object = [User getObjectById:[dict safeLongLongForKey:@"userid"] context:context];
    }
    if (object == nil)
    {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        [User updateObject:object withDict:dict context:context];
        [AppDelegateInstance saveContext];
    }
    else
    {
        [User updateObject:object withDict:dict context:context];
        [AppDelegateInstance saveContext];
    }
    
    return object;
    
}

+ (instancetype)getObjectById:(long long)id context:(NSManagedObjectContext*)context
{
    NSString* predicateStr = [NSString stringWithFormat:@"user_id = %lld", id];
    return (User*)[DBHelper fetchOneEntity:@"User" predicate:[NSPredicate predicateWithFormat:predicateStr] sorts:nil context:context];
}

+ (void)updateObject:(User*)object withDict:(NSDictionary*)dict context:(NSManagedObjectContext*)context
{
    if ([dict hasObjectForKey:@"userid"]) {
        [object tryUpdateFromDict:dict forModelKey:@"user_id" forNetKey:@"userid" propertyType:PropertyTypeLonglong];
    }
    if ([dict safeStringForKey:@"member_avatar"].length > 0) {
        [object tryUpdateFromDict:dict forModelKey:@"avatar" forNetKey:@"member_avatar" propertyType:PropertyTypeString];
    }
    else
    {
        [object tryUpdateFromDict:dict forModelKey:@"avatar" forNetKey:@"avatar" propertyType:PropertyTypeString];
    }
    [object tryUpdateFromDict:dict forModelKey:@"jpush_id" forNetKey:@"push_id" propertyType:PropertyTypeString];
    if ([dict hasObjectForKey:@"username"]) {
    [object tryUpdateFromDict:dict forModelKey:@"nickname" forNetKey:@"username" propertyType:PropertyTypeString];
    }

    [object tryUpdateFromDict:dict forKey:@"chat_id" propertyType:PropertyTypeString];
    [object tryUpdateFromDict:dict forModelKey:@"chat_password" forNetKey:@"chat_pwd" propertyType:PropertyTypeString];

    [object tryUpdateFromDict:dict forKey:@"is_host" propertyType:PropertyTypeInt];
    [object tryUpdateFromDict:dict forKey:@"is_set" propertyType:PropertyTypeInt];
    [object tryUpdateFromDict:dict forKey:@"viptype" propertyType:PropertyTypeInt];
    
    [object tryUpdateFromDict:dict forKey:@"member_areaid" propertyType:PropertyTypeString];
    [object tryUpdateFromDict:dict forKey:@"member_cityid" propertyType:PropertyTypeString];
    [object tryUpdateFromDict:dict forKey:@"member_provinceid" propertyType:PropertyTypeString];
}
@end
