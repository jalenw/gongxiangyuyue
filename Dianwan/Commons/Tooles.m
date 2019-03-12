//
//  Tooles.m
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import "Tooles.h"
#import "pinyin.h"
@implementation Tooles
+(UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString*)string{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSDictionary *attrs = @{NSFontAttributeName : font,
                            NSParagraphStyleAttributeName : paragraphStyle.copy};
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent fontSize:(CGFloat)fontSize {
    CGSize size =CGSizeMake(widthInput, 20000.0f);
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[strContent boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.height;
}

+ (UIImage*)getShotWithView:(UIView*)view andSize:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

+(NSString*)getKeyLetter:(NSString*)string
{
    NSString *key;
    if (string.length > 0) {
        char achar = pinyinFirstLetter([string characterAtIndex:0]);
        if ( (achar >= 'a' && achar <= 'z') || (achar >= 'A' && achar <= 'Z')) {
            NSString *letter = [NSString stringWithFormat:@"%c",achar];
            key = [letter uppercaseString];
        }
        else
        {
            key = @"#";
        }
    }
    else
    {
        key = @"#";
    }
    return key;
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (id)stringToJson:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return object;
}

+ (NSString*)jsonToString:(id)json
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(BOOL)isFirstOpen:(NSString *)key
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"everLaunched%@",key]]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"everLaunched%@",key]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}



//判断手机号码格式是否正确

+ (BOOL)valiMobile:(NSString *)mobileNumbel
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}

+ (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

+ (NSString*)getUploadImageName{
    NSDate *date = [NSDate date];
    long long dateTime = date.timeIntervalSince1970*1000;
    int ramValue = arc4random()%10000;
    NSString *fileName = [NSString stringWithFormat:@"%lld_%lld_%d.jpg",AppDelegateInstance.defaultUser.user_id, dateTime, ramValue];
    return fileName;
}

+ (NSDictionary *)getDictFromUrlString:(NSString *)urlString{
    NSArray *array1 = [urlString componentsSeparatedByString:@"?"];
    NSString *paramsString = [array1 lastObject];
    NSArray *array2 = [paramsString componentsSeparatedByString:@"&"];
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:array2.count];
    
    for (int i = 0; i < array2.count; ++i) {
        NSString *keyValueString = array2[i];
        NSArray *keyValue = [keyValueString componentsSeparatedByString:@"="];
        NSString *key = [keyValue firstObject];
        NSString *value = [keyValue lastObject];
        resultDict[key] = value;
    }
    
    return resultDict;
}

+ (NSString*)getUrlStringParamFromDict:(NSDictionary*)dict{
    NSString *result = @"";
    NSArray *allkey = dict.allKeys;
    for (int i = 0; i < allkey.count; ++i) {
        NSString *key = allkey[i];
        NSString *value = dict[key];
        if (i == 0) {
            result = [result stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else{
            result = [result stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }
        
        
    }
    return result;
}


double LantitudeLongitudeDist(double lon1,double lat1,
                              double lon2,double lat2)
{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}
@end
