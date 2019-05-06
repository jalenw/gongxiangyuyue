//
//  MineAndHistoryViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MineAndHistoryViewController.h"
#import "MineViewController.h"
#import "MineHistoryViewController.h"
@interface MineAndHistoryViewController ()

@end

@implementation MineAndHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挖矿";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self requestMarkdataAct];
}

//重写右按钮
- (UIButton*)setRightBarButtonWithTitle:(NSString*)title{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:ThemeColor range:NSMakeRange(5,attrString.length-6)];
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightbarButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = DefaultFontOfSize(15);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem sx_setRightBarButtonItems:@[rightBarItem]];
    return button;
}


-(void)rightbarButtonDidTap:(UIButton *)button{
    if (![HTTPClientInstance isLogin]) {
        [AppDelegateInstance showLoginView];
    }
    else
    {
        CommonUIWebViewController *commonweb =[[CommonUIWebViewController alloc]init];
        commonweb.address =[NSString stringWithFormat:@"%@dist/dig/mill",web_url];
        commonweb.showNav = NO;
        [self.navigationController pushViewController:commonweb animated:YES];
    }
    
}

-(void)requestMarkdataAct{
    NSDictionary *params = @{ @"page":@(1)};
    [[ServiceForUser manager] postMethodName:@"minemachine/mineMachineList" params:params block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [self setRightBarButtonWithTitle:[NSString stringWithFormat:@"我的矿机(%d)",[[data safeDictionaryForKey:@"result"] safeIntForKey:@"num"]]];
        }else{
            [AlertHelper showAlertWithTitle:error];
        }
    }];
    
}

- (NSArray<NSString *> *)buttonTitleArray{
    return @[@"矿机",@"历史矿机"];
}

-(UIColor *)BtnbackgroundColor{
    return [UIColor whiteColor];
}

- (BOOL)isAllowScroll{
    return YES;
}

-(UIColor *)normalTabTextColor{
    return [UIColor blackColor];
}

-(UIColor *)selectTabTextColor{
    return ThemeColor;
}


-(UIColor *)indicatorColor{
    return  ThemeColor;
}

-(CGFloat)indicatorWidth{
    return 80;
}

- (CGFloat)indicatorOffset{
    return (ScreenWidth/2-80)/2;
}

- (void)setupControllers{
    self.scrollView.top = 0;
    self.scrollView.height = ScreenHeight-64;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (UIViewController *controller in self.controllerArray) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    NSArray *titleArray = [self buttonTitleArray];
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArray.count; ++i) {
        UIViewController *controller = nil;
        if(i == 0){
            MineViewController *subController = [[MineViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
            self.currentController = controller;
        }else if (i == 1){
            MineHistoryViewController *subController = [[MineHistoryViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
        }
        controller.view.height = self.scrollView.height;
        controller.view.width = ScreenWidth;
        controller.view.left = i*ScreenWidth;
        [self.scrollView addSubview:controller.view];
        [controllerArray addObject:controller];
    }
    self.controllerArray = [NSArray arrayWithArray:controllerArray];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*titleArray.count, 0);
    self.topHeaderView.top = 0;
    self.topHeaderView.backgroundColor = [UIColor clearColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [topView addSubview:self.topHeaderView];
    [self.view addSubview:topView];
}

- (CGFloat)topHeaderWidth{
    return ScreenWidth;
}

- (UIView*)createTopHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}
@end
