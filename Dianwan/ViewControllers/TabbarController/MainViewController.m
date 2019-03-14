//
//  MainViewController.m
//  SinaWeibo
//
//  Created by user on 15/10/13.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "MainViewController.h"
#import "ZTNavigationController.h"
#import "ZTTabBar.h"
#import "FirstViewController.h"
#import "MyViewController.h"
#import "EaseConversationListViewController.h"
#import "ChatViewController.h"
#import "MineViewController.h"
#import "MarketViewController.h"
@interface MainViewController ()<IChatManagerDelegate,EaseConversationListViewControllerDelegate>
{
    NSInteger unreadMessageCount;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVc:[[FirstViewController alloc] init] title:@"首页" image:@"tabbar_menu1_normal" selectedImage:@"tabbar_menu1_selected"];
    [self addChildVc:[[MarketViewController alloc] init] title:@"市场" image:@"tabbar_menu2_normal" selectedImage:@"tabbar_menu2_selected"];
    EaseConversationListViewController *chatVc = [[EaseConversationListViewController alloc] init];
    chatVc.delegate = self;
    [self addChildVc:chatVc title:@"聊天" image:@"tabbar_menu3_normal" selectedImage:@"tabbar_menu3_selected"];
    [self addChildVc:[[MineViewController alloc] init]  title:@"挖矿" image:@"tabbar_menu4_normal" selectedImage:@"tabbar_menu4_selected"];
    [self addChildVc:[[MyViewController alloc] init] title:@"我的" image:@"tabbar_menu5_normal" selectedImage:@"tabbar_menu5_selected"];
    
//   tabbar中间按钮
//    ZTTabBar *tabBar = [[ZTTabBar alloc] init];
//    tabBar.backgroundImage = [Tooles createImageWithColor:RGB(25, 31, 40)];
//    tabBar.delegate = self;
//    tabBar.shadowImage = [Tooles createImageWithColor:RGB(25, 31, 40)];
//    [self setValue:tabBar forKey:@"tabBar"];

    AppDelegateInstance.currentNavigationController =  self.childViewControllers[0];
    
     [self registerNotifications];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(123, 123, 123)} forState:UIControlStateNormal];
    
    [childVc.tabBarItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : ThemeColor} forState:UIControlStateSelected];
    
    UIOffset offset;
    offset.horizontal = 0.0;
    offset.vertical = 0.0;    [childVc.tabBarItem setTitlePositionAdjustment:offset];

    // 为子控制器包装导航控制器
    ZTNavigationController *navigationVc = [[ZTNavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

#pragma ZTTabBarDelegate
/**
 *  中间按钮点击
 */
- (void)tabBarDidClickPlusButton:(ZTTabBar *)tabBar
{

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [tabBar.items indexOfObject:item];
    AppDelegateInstance.currentNavigationController =  self.childViewControllers[index];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

-(void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

-(void)didReceiveMessage:(EMMessage *)message
{
}

//跳转到环信聊天界面
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
           NSDictionary *dict = [Tooles stringToJson:[conversation.latestMessage.ext safeStringForKey:@"ext"]];
                ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.chatter conversationType:conversation.conversationType];
                chatController.title = @"";
                [AppDelegateInstance.currentNavigationController pushViewController:chatController animated:YES];
        }
    }
}

@end
