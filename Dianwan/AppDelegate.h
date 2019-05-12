//
//  AppDelegate.h
//  happy
//
//  Created by noodle on 16/9/12.
//  Copyright © 2016年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"
#import "JPUSHService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define AppDelegateInstance ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define base_url [[[NSBundle mainBundle] infoDictionary] objectForKey:@"base_url"]//请求地址
#define web_url [[[NSBundle mainBundle] infoDictionary] objectForKey:@"web_url"]//跳转H5页面开头部分

@class User;
@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate>
@property (strong, nonatomic) User *defaultUser;//保存登录用户信息
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) UINavigationController *currentNavigationController;//当前导航栏
@property (strong, nonatomic) MainViewController* mainViewController;//主界面
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) BOOL showUserCenter;
- (void)showMainPage;//进入主界面
- (void)showLoginView;//打开登录页
- (void)saveContext;//保存数据库
- (void)resetCoreData;//重启数据库
- (NSURL *)applicationDocumentsDirectory;
-(void)logout;//登出
@end

