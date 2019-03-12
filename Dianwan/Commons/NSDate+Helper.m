//
//  NSDate+Helper.m
//  Ekeo2
//
//  Created by Roger on 13-8-20.
//  Copyright (c) 2013年 Ekeo. All rights reserved.
//


#define S_Aries                 @"白羊"
#define S_Taurus                @"金牛"
#define S_Gemini                @"双子"
#define S_Cancer                @"巨蟹"
#define S_Leo                   @"狮子"
#define S_Virgo                 @"处女"
#define S_Libra                 @"天秤"
#define S_Scorpio               @"天蝎"
#define S_Sagittarius           @"射手"
#define S_Capricorn             @"摩羯"
#define S_Aquarius              @"水瓶"
#define S_Pisces                @"双鱼"

#pragma mark - Date

#define S_JustNow               @"刚刚"
#define S_Today                 @"今天"
#define S_Yesterday             @"昨天"
#define S_MinutesAgo            @"%d分钟前"
#define S_HoursAgo              @"%d小时前"
#define S_DaysAgo               @"%d天前"

#define S_Sunday                @"星期天"
#define S_Monday                @"星期一"
#define S_Tuesday               @"星期二"
#define S_Webnesday             @"星期三"
#define S_Thursday              @"星期四"
#define S_Friday                @"星期五"
#define S_Saturday              @"星期六"

#define S_ShortDateFormatter    @"M月d日"
#define S_TimeFormatter         @"H:mm"
#define S_DateTimeFormatter     @"M月d日 H:mm"
#define S_YearDateTimeFormatter @"YYYY年M月d日 H:mm"
#define S_DateYearFormatter     @"YYYY-MM-dd"
#define S_BirthdayFormatter     @"YYYY年MM月dd日"


#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate*)localizeDate
{
    NSDate* date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSString*)weakdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    
    switch (dateComponents.weekday) {
        case 1:
            return S_Sunday;
            break;
        case 2:
            return S_Monday;
            break;
        case 3:
            return S_Tuesday;
            break;
        case 4:
            return S_Webnesday;
            break;
        case 5:
            return S_Thursday;
            break;
        case 6:
            return S_Friday;
            break;
        case 7:
            return S_Saturday;
            break;
        default:
            return nil;
            break;
    }
}

static NSDateFormatter *_shortDateFormatter;
static NSDateFormatter *_timeFormatter;
static NSDateFormatter *_dateTimeFormatter;
static NSDateFormatter *_yearDateTimeFormatter;
static NSDateFormatter *_dateYearFormatter;
static NSDateFormatter *_birthdayFormatter;

+ (void)initialize
{
    [super initialize];
    
    _shortDateFormatter = [[NSDateFormatter alloc] init];
    [_shortDateFormatter setDateFormat:S_ShortDateFormatter];
    
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setDateFormat:S_TimeFormatter];
    
    _dateTimeFormatter = [[NSDateFormatter alloc]init];
    [_dateTimeFormatter setDateFormat:S_DateTimeFormatter];
    
    _yearDateTimeFormatter = [[NSDateFormatter alloc]init];
    [_yearDateTimeFormatter setDateFormat:S_YearDateTimeFormatter];
    
    _dateYearFormatter = [[NSDateFormatter alloc] init];
    [_dateYearFormatter setDateFormat:S_DateYearFormatter];
    
    _birthdayFormatter = [[NSDateFormatter alloc] init];
    [_birthdayFormatter setDateFormat:S_BirthdayFormatter];
}

+ (NSString*)getXinZuoOfInterval:(double)interval{
    if(interval == 0)
        return @"";
    
    //计算星座
    NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970: interval/1000.0f];
    
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:birthDate];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:birthDate];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=S_Aquarius;
            }
            if(i_day>=1 && i_day<=19){
                retStr=S_Capricorn;
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=S_Aquarius;
            }
            if(i_day>=19 && i_day<=31){
                retStr=S_Pisces;
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=S_Pisces;
            }
            if(i_day>=21 && i_day<=31){
                retStr=S_Aries;
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=S_Aries;
            }
            if(i_day>=20 && i_day<=31){
                retStr=S_Taurus;
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=S_Taurus;
            }
            if(i_day>=21 && i_day<=31){
                retStr=S_Gemini;
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=S_Gemini;
            }
            if(i_day>=22 && i_day<=31){
                retStr=S_Cancer;
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=S_Cancer;
            }
            if(i_day>=23 && i_day<=31){
                retStr=S_Leo;
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=S_Leo;
            }
            if(i_day>=23 && i_day<=31){
                retStr=S_Virgo;
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=S_Virgo;
            }
            if(i_day>=23 && i_day<=31){
                retStr=S_Libra;
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=S_Libra;
            }
            if(i_day>=24 && i_day<=31){
                retStr=S_Scorpio;
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=S_Scorpio;
            }
            if(i_day>=22 && i_day<=31){
                retStr=S_Sagittarius;
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=S_Sagittarius;
            }
            if(i_day>=21 && i_day<=31){
                retStr=S_Capricorn;
            }
            break;
    }
    return retStr;
}

+ (NSString*)birthdayStringOfInterval:(double)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];
    return [_birthdayFormatter stringFromDate:date];
}

+ (NSString*)shortDateOfInterval:(double)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval / 1000.0f];
    return [_shortDateFormatter stringFromDate:date];
}

+ (NSString *)feedTimeOfInterval:(double)interval{
    if (interval <= 0) {
        return @"刚刚";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];
    NSTimeInterval intervalSinceNow = [[NSDate date] timeIntervalSinceDate:date];
    if (intervalSinceNow < 60) {
        return S_JustNow;
    }
    else if (intervalSinceNow < 3600)
    {
        return [NSString stringWithFormat:S_MinutesAgo, (int)(intervalSinceNow / 60)];
    }
    else if (intervalSinceNow < 24 * 3600)
    {
        return [NSString stringWithFormat:S_HoursAgo, (int)(intervalSinceNow / 3600)];
    }else if (intervalSinceNow < 30 * 24 * 3600 ){
        return [NSString stringWithFormat:S_DaysAgo, (int)(intervalSinceNow / (24 * 3600))];
    }else if (intervalSinceNow < 12 * 30 * 24 * 3600 ){
        return [NSString stringWithFormat:@"%d个月前", (int)(intervalSinceNow / (24 * 3600 * 30))];
    }else{
        return [NSString stringWithFormat:@"%d年前", (int)(intervalSinceNow / (12 * 24 * 3600 * 30))];
    }
}


+ (NSString*)dateYearStringOfInterval:(double)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];
    
    return [_dateYearFormatter stringFromDate:date];
}

+ (NSString *)dateYearDateTimeFormatter:(double)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];
    
    return [_yearDateTimeFormatter stringFromDate:date];
}

+ (NSString*)timeOfInterval:(double)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];
    return [_timeFormatter stringFromDate:date];
}

+(NSInteger)ageOfBirthTimeInterval:(double)interval
{
    
    NSDate *dateOfBirth = [NSDate dateWithTimeIntervalSince1970:interval/1000.0f];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        
    } else {
        
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}
@end
