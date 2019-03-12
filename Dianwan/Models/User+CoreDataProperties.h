//
//  User+CoreDataProperties.h
//  happy
//
//  Created by noodle on 16/9/19.
//  Copyright © 2016年 intexh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)
//头像
@property (nullable, nonatomic, retain) NSString *avatar;
//环信ID
@property (nullable, nonatomic, retain) NSString *chat_id;
//环信密码
@property (nullable, nonatomic, retain) NSString *chat_password;
//用户昵称
@property (nullable, nonatomic, retain) NSString *nickname;
//极光推送id
@property (nullable, nonatomic, retain) NSString *jpush_id;
//手机
@property (nullable, nonatomic, retain) NSString *phone;
//性别
@property (nonatomic, assign) int16_t sex;
//生日
@property (nonatomic, nullable,retain) NSString *birthday;
//用户id
@property (nonatomic ) int64_t user_id;

@property (nonatomic, assign) int16_t is_host;
@property (nonatomic, assign) int16_t is_set;
@property (nonatomic, assign) int16_t viptype;

@property (nullable, nonatomic, retain) NSString *member_areaid;
@property (nullable, nonatomic, retain) NSString *member_cityid;
@property (nullable, nonatomic, retain) NSString *member_provinceid;
@end

@interface User (CoreDataGeneratedAccessors)


@end

NS_ASSUME_NONNULL_END
