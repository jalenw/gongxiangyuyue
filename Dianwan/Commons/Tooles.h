//
//  Tooles.h
//  xunyu
//
//  Created by noodle on 16/6/22.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tooles : NSObject
//颜色转图片
+(UIImage*)createImageWithColor:(UIColor*)color;

//计算字符串大小
+(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString*)string;
//计算文本所占高度
//2个参数：宽度和文本内容
+ (CGFloat)calculateTextHeight:(CGFloat)widthInput Content:(NSString *)strContent fontSize:(CGFloat)fontSize;
//截屏
+ (UIImage*)getShotWithView:(UIView*)view andSize:(CGRect)rect;
/**
 *  返回名字首拼音字母
 *
 *  @param string 名字
 *
 *  @return 首字母
 */
+(NSString*)getKeyLetter:(NSString*)string;
//是否合法邮箱
+(BOOL)isValidateEmail:(NSString *)email;
/**
 *  字符串转json
 */
+ (id)stringToJson:(NSString *)jsonString;
/**
 *  json转字符串
 */
+ (NSString*)jsonToString:(id)json;
//判断是否第一次打开
+(BOOL)isFirstOpen:(NSString *)key;
//判断是否为身份证
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//返回中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

//获取上传图片名
+ (NSString*)getUploadImageName;

+ (NSDictionary *)getDictFromUrlString:(NSString *)urlString;
+ (NSString*)getUrlStringParamFromDict:(NSDictionary*)dict;

//计算两个经纬度直接距离
double LantitudeLongitudeDist(double lon1,double lat1,
                              double lon2,double lat2);


//获取当前控制器
+ (UIViewController*)currentViewController;
@end
