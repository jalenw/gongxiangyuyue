//
//  DBHelper.h
//  Ekeo2
//
//  Created by kenny on 9/4/13.
//  Copyright (c) 2013 Ekeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBHelper : NSObject

+ (NSArray*)fetchEntity:(NSString*)entityName
              predicate:(NSPredicate*)predicate
                  sorts:(NSArray*)sortDescriptors
               pageSize:(int)pageSize
              pageIndex:(int)pageIndex
                context:(NSManagedObjectContext*)context;

+ (NSManagedObject*)fetchOneEntity:(NSString*)entityName
                         predicate:(NSPredicate*)predicate
                             sorts:(NSArray*)sortDescriptors
                           context:(NSManagedObjectContext*)context;

+ (NSUInteger)countForFetchEntity:(NSString*)entityName
                        predicate:(NSPredicate*)predicate
                          context:(NSManagedObjectContext*)context;

+ (NSManagedObject*)deleteOneEntity:(NSString*)entityName
                          predicate:(NSPredicate*)predicate
                              sorts:(NSArray*)sortDescriptors
                            context:(NSManagedObjectContext*)context;

+ (NSArray*)deleteEntity:(NSString*)entityName
               predicate:(NSPredicate*)predicate
                 context:(NSManagedObjectContext*)context;
@end
