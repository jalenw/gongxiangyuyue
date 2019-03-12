//
//  NSDate+Helper.h
//  Ekeo2
//
//  Created by Roger on 13-8-20.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (NSDate*)localizeDate;
+ (NSString*)weakdayFromDate:(NSDate*)date;//转化成星期几
+ (NSString*)getXinZuoOfInterval:(double)interval;//转化成星座
+ (NSString*)birthdayStringOfInterval:(double)interval;//"YYYY年MM月dd日"
+ (NSString *)dateYearDateTimeFormatter:(double)interval;//"YYYY年M月d日 H:mm"
+ (NSString*)dateYearStringOfInterval:(double)interval;//"YYYY-MM-dd"
+ (NSString*)shortDateOfInterval:(double)interval;//"M月d日"
+ (NSString*)timeOfInterval:(double)interval;//"H:mm"
+ (NSString*)feedTimeOfInterval:(double)interval;//多久前
+(NSInteger)ageOfBirthTimeInterval:(double)interval;//几岁


@end
