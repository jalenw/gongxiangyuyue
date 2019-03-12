//
//  DBHelper.m
//  Ekeo2
//
//  Created by kenny on 9/4/13.
//  Copyright (c) 2013 Ekeo. All rights reserved.
//

#import "DBHelper.h"
#import "AppDelegate.h"

@implementation DBHelper

+ (NSArray*)fetchEntity:(NSString*)entityName
              predicate:(NSPredicate*)predicate
                  sorts:(NSArray*)sortDescriptors
               pageSize:(int)pageSize
              pageIndex:(int)pageIndex
                context:(NSManagedObjectContext*)context;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    if (predicate != nil)
    {
//        if ([entityName isEqualToString:kPostEntityName])
//        {
//            NSString *preString = predicate.predicateFormat;
//            preString = [preString stringByAppendingFormat:@" AND %@ = %d", kPostIsDeleted, 0];
//            predicate = [NSPredicate predicateWithFormat:preString];
//        }
        
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors != nil && sortDescriptors.count > 0)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (pageSize > 0)
    {
        [fetchRequest setFetchLimit:pageSize];
        [fetchRequest setFetchOffset:pageSize * pageIndex];
    }
    
    NSError *error = NULL;
   
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    return array;
}

+ (NSManagedObject*)fetchOneEntity:(NSString*)entityName
                         predicate:(NSPredicate*)predicate
                             sorts:(NSArray*)sortDescriptors
                           context:(NSManagedObjectContext*)context
{
    NSManagedObject *object = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors != nil && sortDescriptors.count > 0)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    if (array !=nil && [array count] > 0)
    {
        object = [array objectAtIndex:0];
    }
    
    return object;
}

+ (NSManagedObject*)deleteOneEntity:(NSString*)entityName
                         predicate:(NSPredicate*)predicate
                             sorts:(NSArray*)sortDescriptors
                           context:(NSManagedObjectContext*)context
{
    NSManagedObject *object = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors != nil && sortDescriptors.count > 0)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    [fetchRequest setFetchLimit:1];
    
    NSError *error = NULL;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    else
    {
        for(id object in array)
        {
            [context deleteObject:object];
        }
        
    }
    if (array !=nil && [array count] > 0)
    {
        object = [array objectAtIndex:0];
    }
    
    return object;
}

+ (NSArray*)deleteEntity:(NSString*)entityName
                          predicate:(NSPredicate*)predicate
                            context:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }

    
    [fetchRequest setFetchLimit:0];
    
    NSError *error = NULL;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    else
    {
        for(id object in array)
        {
            [context deleteObject:object];
        }
        
    }
    
    return array;
}

+ (NSUInteger)countForFetchEntity:(NSString*)entityName
                        predicate:(NSPredicate*)predicate
                          context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    if (predicate != nil)
    {
        [fetchRequest setPredicate:predicate];
    }
    
    NSError *error = NULL;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    return count;
}

@end
