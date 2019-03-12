//
//  NSManagedObject+Helper.h
//  Pair
//
//  Created by Enoch on 8/18/14.
//  Copyright (c) 2014 feather. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum
{
    PropertyTypeBoolean,
    PropertyTypeInt,
    PropertyTypeLonglong,
    PropertyTypeFloat,
    PropertyTypeDouble,
    PropertyTypeString,
    PropertyTypeObject
} PropertyType;

@interface NSManagedObject (Helper)

- (void)tryUpdateFromDict:(NSDictionary*)dict forKey:(NSString*)key propertyType:(PropertyType)propertyType;
- (void)tryUpdateFromDict:(NSDictionary*)dict forModelKey:(NSString*)modelKey forNetKey:(NSString*)netKey propertyType:(PropertyType)propertyType;
- (void)tryUpdateFromDict:(NSDictionary*)dict forModelKey:(NSString*)modelKey forNetKey:(NSString*)netKey propertyType:(PropertyType)propertyType completion:(void (^)(BOOL))completion;

- (void)tryUpdateRelation:(id)relation forKey:(NSString*)key;
- (void)tryUpdateRelationSet:(NSSet*)set forKey:(NSString*)key;
- (void)tryUpdateRelationOrderedSet:(NSOrderedSet*)orderedSet forKey:(NSString*)key;
@end
