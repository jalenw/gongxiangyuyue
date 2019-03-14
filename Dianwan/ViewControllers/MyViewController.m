//
//  MyViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "MyViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"
#import "UserViewController.h"
#import "MessageParentViewcontroller.h"
#import "QRCodeViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (AppDelegateInstance.defaultUser!=nil) {
        [self.pic sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
        self.name.text = AppDelegateInstance.defaultUser.nickname;
    }
    else
    {
        self.name.text = @"请登录";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAct:(UIButton *)sender {
    if (AppDelegateInstance.defaultUser==nil) {
        [AppDelegateInstance showLoginView];
    }
    else
    {
        UserViewController *vc = [[UserViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)toSetingVC:(UIButton *)sender {
    SettingViewController *vc = [[SettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//二维码页面
- (IBAction)toQRCodeVCAct:(UIButton *)sender {
    QRCodeViewController *vc = [[QRCodeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
  
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)menuAct:(UIButton *)sender {
    CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
    
    if (sender.tag==101) {//钱包
        commonweb.address =[NSString stringWithFormat:@"%@dist/person/wallet?",web_url];
    }
    if (sender.tag==102) {//商城订单
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/order_list.html?",web_url];
    }
    if (sender.tag==103) {//约家订单
         commonweb.address =[NSString stringWithFormat:@"%@dist/mall/shopping?shop_id=0",web_url];
    }
    if (sender.tag==106) {//会员升级
        commonweb.address =[NSString stringWithFormat:@"%@dist/mall/shopping?shop_id=0",web_url];
    }
    if (sender.tag==109) {//我的推荐码
         commonweb.address =[NSString stringWithFormat:@"%@wap/member/sharing.html?",web_url];
    }
    if (sender.tag==110) {//我的收藏
         commonweb.address =[NSString stringWithFormat:@"%@wap/member/favorites.html?",web_url];
    }
    if (sender.tag==111) {//收货地址
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/address_list.html?",web_url];
    }
    commonweb.showNav = NO;
    if (commonweb.address.length > 0) {
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==104) {//已购课程
        
    }
    if (sender.tag==105) {//付费直播
        
    }
    if (sender.tag==107) {//消息
        MessageParentViewcontroller *messageCenter = [[MessageParentViewcontroller alloc]init];
        [self.navigationController pushViewController:messageCenter animated:YES];
    }
    if (sender.tag==108) {//客服中心
        if (HTTPClientInstance.isLogin == NO) {
            [AlertHelper showAlertWithTitle:@"请登录后再进行操作"];
            return;
        }
//        if (member_chat_id.length > 0) {
//            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:member_chat_id conversationType:eConversationTypeGroupChat];
//            [self.navigationController pushViewController:chatController animated:YES];
//        }else{
//            [AlertHelper showAlertWithTitle:@"聊天信息有误"];
//            return;
//        }
    }
    
   
  
}
@end
