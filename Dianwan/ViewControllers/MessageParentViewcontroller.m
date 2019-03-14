//
//  MessageParentViewcontroller.m
//  Dianwan
//
//  Created by Yang on 2019/3/13.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MessageParentViewcontroller.h"
#import "PlatformAnnouncementController.h"
#import "SystemMessageViewController.h"
@interface MessageParentViewcontroller()<UITextFieldDelegate>

@end

@implementation MessageParentViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupForDismissKeyboard];
    [self.navigationController setNavigationBarHidden:NO];
   
}

- (NSArray<NSString *> *)buttonTitleArray{
    return @[@"系统消息",@"平台公告"];
}


-(UIColor *)BtnbackgroundColor{
    return RGB(48, 46, 58);
}

- (BOOL)isAllowScroll{
    return YES;
}
-(UIColor *)normalTabTextColor{
    return [UIColor whiteColor];
}

-(UIColor *)selectTabTextColor{
    return  [UIColor colorWithPatternImage:[UIImage imageNamed:@"btt_1"]];//RGB(241, 228, 142);
}


-(UIColor *)indicatorColor{
    return  RGB(251, 185, 55);}

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
            SystemMessageViewController *subController = [[SystemMessageViewController alloc] init];
            controller = subController;
            [self addChildViewController:controller];
            self.currentController = controller;
        }else if (i == 1){
            PlatformAnnouncementController *subController = [[PlatformAnnouncementController alloc] init];
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
