//
//  NSManagedObject+Helper.m
//  Pair
//
//  Created by Enoch on 8/18/14.
//  Copyright (c) 2014 feather. All rights reserved.
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)

- (void)tryUpdateFromDict:(NSDictionary*)dict forKey:(NSString*)key propertyType:(PropertyType)propertyType
{
    [self tryUpdateFromDict:dict forModelKey:key forNetKey:key propertyType:propertyType];
}

- (void)tryUpdateFromDict:(NSDictionary*)dict forModelKey:(NSString*)modelKey forNetKey:(NSString*)netKey propertyType:(PropertyType)propertyType
{
    [self tryUpdateFromDict:dict forModelKey:modelKey forNetKey:netKey propertyType:propertyType completion:nil];
}

- (void)tryUpdateFromDict:(NSDictionary*)dict forModelKey:(NSString*)modelKey forNetKey:(NSString*)netKey propertyType:(PropertyType)propertyType completion:(void (^)(BOOL))completion
{
    BOOL success = NO;
    if ([dict hasObjectForKey:netKey])
    {
        switch (propertyType)
        {
            case PropertyTypeBoolean:
                if (![self valueForKey:modelKey] || ([[self valueForKey:modelKey] boolValue] != [dict safeBoolForkey:netKey]))
                {
                    [self setValue:[NSNumber numberWithInt:[dict safeBoolForkey:netKey]] forKey:modelKey];
                }
                break;
            case PropertyTypeInt:
                if (![self valueForKey:modelKey] || ([[self valueForKey:modelKey] intValue] != [dict safeIntForKey:netKey]))
                {
                    [self setValue:[NSNumber numberWithInt:[dict safeIntForKey:netKey]] forKey:modelKey];
                }
                break;
            case PropertyTypeLonglong:
                if (![self valueForKey:modelKey] || ([[self valueForKey:modelKey] longLongValue] != [dict safeLongLongForKey:netKey]))
                {
                    [self setValue:[NSNumber numberWithLongLong:[dict safeLongLongForKey:netKey]] forKey:modelKey];
                }
                break;
            case PropertyTypeFloat:
                if (![self valueForKey:modelKey] || ([[self valueForKey:modelKey] floatValue] != [dict safeFloatForKey:netKey]))
                {
                    [self setValue:[NSNumber numberWithFloat:[dict safeFloatForKey:netKey]] forKey:modelKey];
                }
                break;
            case PropertyTypeDouble:
                if (![self valueForKey:modelKey] || ([[self valueForKey:modelKey] doubleValue] != [dict safeDoubleForKey:netKey]))
                {
                    [self setValue:[NSNumber numberWithDouble:[dict safeDoubleForKey:netKey]] forKey:modelKey];
                }
                break;
            case PropertyTypeString:
                @try {
                    if (![self valueForKey:modelKey] || ![[self valueForKey:modelKey] isEqualToString:[dict safeStringForKey:netKey]])
                    {
                        [self setValue:[dict safeStringForKey:netKey] forKey:modelKey];
                    }
                }
                @catch (NSException *exception) {
                }
                break;
            case PropertyTypeObject:
                if (![self valueForKey:modelKey] || ![[self valueForKey:modelKey] isEqual:[dict safeObjectForKey:netKey]])
                {
                    [self setValue:[dict safeObjectForKey:netKey] forKey:modelKey];
                }
                break;
                
            default:
                break;
        }
    }
    else
    {
        if (propertyType == PropertyTypeString)
        {
            if (![self valueForKey:modelKey])
            {
                [self setValue:@"" forKey:modelKey];
            }
        }
    }
    
    if (completion)
    {
        completion(success);
    }
}

- (void)tryUpdateRelation:(id)relation forKey:(NSString*)key
{
    if (relation)
    {
        id localRelation = [self valueForKey:key];
        if (localRelation != relation)
        {
            [self setValue:relation forKey:key];
        }
    }
}

- (void)tryUpdateRelationSet:(NSSet*)set forKey:(NSString*)key
{
    NSSet* localSet = [self valueForKey:key];
    BOOL needToUpdate = (localSet.count != set.count);
    if (localSet.count == set.count)
    {
        for (NSManagedObject* item in set)
        {
            if (![localSet containsObject:item])
            {
                needToUpdate = YES;
                break;
            }
        }
    }
    
    if (needToUpdate)
    {
        [self setValue:set forKey:key];
    }
}

- (void)tryUpdateRelationOrderedSet:(NSOrderedSet*)orderedSet forKey:(NSString*)key
{
    NSOrderedSet* localOrderedSet = [self valueForKey:key];
    BOOL needToUpdate = (localOrderedSet.count != orderedSet.count);
    if (localOrderedSet.count == orderedSet.count)
    {
        for (int i = 0; i < orderedSet.count; i++)
        {
            if ([orderedSet objectAtIndex:i] != [localOrderedSet objectAtIndex:i])
            {
                needToUpdate = YES;
                break;
            }
        }
    }
    
    if (needToUpdate)
    {
        [self setValue:orderedSet forKey:key];
    }
}

@end
