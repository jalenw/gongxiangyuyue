//
//  MyViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "MyViewController.h"
#import "SettingViewController.h"
#import "UserViewController.h"
#import "MessageParentViewcontroller.h"
#import "QRCodeViewController.h"
#import "AddLineViewController.h"
#import "AlreadybuyViewController.h"
#import "OrderParentViewcontroller.h"
#import "ChatViewController.h"

@interface MyViewController ()
@property (weak, nonatomic) IBOutlet UIView *qrcodeBtn;
@property (weak, nonatomic) IBOutlet UIView *settingBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    //适配大屏幕
    if(IS_IPHONE_Xr||IS_IPHONE_X||IS_IPHONE_Xs_Max){
        CGRect frome = self.userCoverimageView.frame;
        frome.origin.y =  85;
        self.userCoverimageView.frame = frome;
        
        CGRect codebtnfrome = self.qrcodeBtn.frame;
        codebtnfrome.origin.y = 49;
        self.qrcodeBtn.frame = codebtnfrome;
        
        CGRect setbtnfrome = self.settingBtn.frame;
        setbtnfrome.origin.y = 49;
        self.settingBtn.frame = setbtnfrome;
        
        CGRect nameLabelFrame = self.nameLabel.frame;
        nameLabelFrame.origin.y = self.userCoverimageView.bottom +16;
        self.nameLabel.frame = nameLabelFrame;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (AppDelegateInstance.defaultUser!=nil) {
        [self.pic sd_setImageWithURL:[NSURL URLWithString:AppDelegateInstance.defaultUser.avatar]];
        self.name.text = AppDelegateInstance.defaultUser.nickname;
        [self requestUserinfo];
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
    if(![HTTPClientInstance isLogin]){
         [AppDelegateInstance showLoginView];
    }else{
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
 
}

//二维码页面
- (IBAction)toQRCodeVCAct:(UIButton *)sender {
    QRCodeViewController *vc = [[QRCodeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)menuAct:(UIButton *)sender {
    //是否已经登录
    if (![HTTPClientInstance isLogin]) {
        [AppDelegateInstance showLoginView];
        return;
    }
    if (sender.tag == 109 ) {//我的推荐码
        QRCodeViewController *qrcode= [[QRCodeViewController alloc]init];
        [self.navigationController pushViewController:qrcode animated:YES];
    }
    if (sender.tag==104) {//已购课程
       
//        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
//        commonweb.address =[NSString stringWithFormat:@"%@dist/course/buyedDetail?",web_url];
//        commonweb.showNav = NO;
//        [self.navigationController pushViewController:commonweb animated:YES];
        AlreadybuyViewController *alreadBuy = [[AlreadybuyViewController alloc]init];
        [self.navigationController pushViewController:alreadBuy animated:YES];
    }
    if (sender.tag==105) {
        AddLineViewController *vc = [[AddLineViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        LiveListViewController *list = [[LiveListViewController alloc]init];
//        [self.navigationController pushViewController:list  animated:YES];
    }
    if (sender.tag==107) {//消息
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/text/list",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==108) {//客服中心
        if (HTTPClientInstance.isLogin == NO) {
            [AlertHelper showAlertWithTitle:@"请登录后再进行操作"];
            return;
        }
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"" conversationType:eConversationTypeGroupChat];
            [self.navigationController pushViewController:chatController animated:YES];

  }

    if (sender.tag==101) {//钱包
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/person/wallet?",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==102) {//商城订单
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/order_list.html?",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==103) {//约家订单
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/appointment/order?vipType=%d&longitude=%f&latitude=%f",web_url,AppDelegateInstance.defaultUser.viptype,[LocationService sharedInstance].lastLocation.coordinate.longitude,[LocationService sharedInstance].lastLocation.coordinate.latitude];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==106) {//会员升级
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/mall/shopping?shop_id=0&vip_type=%d&longitude=%f&latitude=%f",web_url,AppDelegateInstance.defaultUser.viptype,[LocationService sharedInstance].lastLocation.coordinate.longitude,[LocationService sharedInstance].lastLocation.coordinate.latitude];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==110) {//我的收藏
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/favorites.html?",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    if (sender.tag==111) {//收货地址
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@wap/member/address_list.html?",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
  
}


//获取个人信息
-(void)requestUserinfo{
    [[ServiceForUser manager] postMethodName:@"member/get_user_info" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            NSDictionary *result = [data safeDictionaryForKey:@"result"];
//           if([result safeIntForKey:@"viptype"] == 1){
               self.typeLabel.hidden = NO;
              self.offlineLabel.hidden = NO;
               self.typeLabel.frame = CGRectMake(self.nameLabel.left +0.5*self.nameLabel.width - 5 - [Tooles sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(210, 21) string:@" 会员 "].width, self.nameLabel.bottom+5, [Tooles sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(210, 21) string:@" 会员 "].width,self.nameLabel.height-4);
               self.typeLabel.text =@" 会员 ";
               self.typeLabel.cornerRadius = 4;
               self.typeLabel.layer.masksToBounds = YES;
               
               self.offlineLabel.frame =CGRectMake(self.typeLabel.right+10 , self.typeLabel.top, [Tooles sizeWithFont:[UIFont systemFontOfSize:10.0] maxSize:CGSizeMake(210, 21) string: [NSString stringWithFormat:@" 下线%@人",[result safeStringForKey:@"subordinate"]]].width, self.typeLabel.height);
               self.offlineLabel.text =[NSString stringWithFormat:@" 下线%@人",[result safeStringForKey:@"subordinate"]];
               self.offlineLabel.cornerRadius = 4;
               self.offlineLabel.layer.masksToBounds = YES;
            
//                }
//            if([result safeIntForKey:@"viptype"] == 2){
//                self.typeLabel.hidden = NO;
//                self.rentLabel.hidden = NO;
//                self.offlineLabel.hidden = NO;
//
//                self.rentLabel.frame =CGRectMake(self.nameLabel.left +0.5*self.nameLabel.width - 5, self.nameLabel.bottom+5, [Tooles sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(210, 21) string:@"租用"].width,self.nameLabel.height-4);
//                self.rentLabel.text =@" 租用 ";
//                self.rentLabel.cornerRadius = 4;
//                self.rentLabel.layer.masksToBounds = YES;
//
//                self.typeLabel.frame =CGRectMake(self.rentLabel.left - [Tooles sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(210, 21) string:self.rentLabel.text].width - 10 , self.rentLabel.top, [Tooles sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(210, 21) string:@" 会员 "].width, self.rentLabel.height);
//                self.typeLabel.text =@" 会员 ";
//                self.typeLabel.cornerRadius = 4;
//                self.typeLabel.layer.masksToBounds = YES;
//
//
//                self.offlineLabel.frame =CGRectMake(self.rentLabel.right+10 , self.rentLabel.top, [Tooles sizeWithFont:[UIFont systemFontOfSize:10.0] maxSize:CGSizeMake(210, 21) string: [NSString stringWithFormat:@" 下线%@人",[result safeStringForKey:@"subordinate"]]].width, self.rentLabel.height);
//                self.offlineLabel.text =[NSString stringWithFormat:@" 下线%@人",[result safeStringForKey:@"subordinate"]];
//                self.offlineLabel.cornerRadius = 4;
//                self.offlineLabel.layer.masksToBounds = YES;
//            }
            
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
}
@end
