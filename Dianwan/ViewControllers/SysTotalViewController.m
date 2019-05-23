//
//  SysTotalViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/23.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "SysTotalViewController.h"
#import "SysAddViewController.h"
#import "SystemMsgViewController.h"
@interface SysTotalViewController ()

@end

@implementation SysTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    // Do any additional setup after loading the view from its nib.
}

- (NSArray<NSString *> *)buttonTitleArray{
    return @[@"审核",@"添加"];
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
            SystemMsgViewController *subController = [[SystemMsgViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
            self.currentController = controller;
        }else if (i == 1){
            SysAddViewController *subController = [[SysAddViewController alloc] init];
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
