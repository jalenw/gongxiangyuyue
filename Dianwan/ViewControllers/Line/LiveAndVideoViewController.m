//
//  LiveAndVideoViewController.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "LiveAndVideoViewController.h"
#import "LiveListViewController.h"
#import "VideoListViewController.h"
#import "AddLineViewController.h"
#import "LivePlayerViewController.h"
#import "PreviewViewController.h"
@interface LiveAndVideoViewController ()

@end

@implementation LiveAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播视频";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (AppDelegateInstance.defaultUser.viptype==2) {
        [self setRightBarButtonWithTitle:@"我要开播"];
    }
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    AddLineViewController *vc = [[AddLineViewController alloc]init];
    [vc setBlock:^(NSDictionary * _Nonnull dict) {
        LivePlayerViewController *vc = [[LivePlayerViewController alloc]init];
        vc.forPush = true;
        vc.url = [[dict safeDictionaryForKey:@"result"]safeStringForKey:@"push_rtmp"];
        vc.dict = [dict safeDictionaryForKey:@"result"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<NSString *> *)buttonTitleArray{
    return @[@"直播",@"预告",@"视频"];
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
            LiveListViewController *subController = [[LiveListViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
            self.currentController = controller;
        }else if (i == 1){
            PreviewViewController *subController = [[PreviewViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
        }else if (i == 2){
            VideoListViewController *subController = [[VideoListViewController alloc] init];
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
