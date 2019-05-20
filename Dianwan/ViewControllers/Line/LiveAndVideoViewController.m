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
{
    NSMutableArray *classList;
    NSDictionary *classDict;
}
@end

@implementation LiveAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播视频";
    classList = [[NSMutableArray alloc]init];
    [classList addObject:@"全部"];
    [self getClassList];
}

-(void)getClassList
{
    [[ServiceForUser manager]postMethodName:@"channelclass/getClassList" params:nil block:^(NSDictionary *data, NSString *error, BOOL status, NSError *requestFailed) {
        if (status) {
            [classList addObjectsFromArray:[data  safeArrayForKey:@"result"]];
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setRightBarButtonWithTitle:@"筛选"];
}

-(void)rightbarButtonDidTap:(UIButton *)button
{
    self.typeView.hidden = NO;
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
    return (ScreenWidth/3-80)/3;
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
    [self.view addSubview:self.typeView];
}

- (CGFloat)topHeaderWidth{
    return ScreenWidth;
}

- (UIView*)createTopHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"typeCell"];
    }
    if (classList.count>0) {
        if (indexPath.row==0) {
            cell.textLabel.text = [classList firstObject];
        }
        else
        {
            NSDictionary *dict = [classList objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict safeStringForKey:@"class_name"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        classDict = nil;
        AppDelegateInstance.classId = nil;
    }else
    {
        NSDictionary *dict = [classList objectAtIndex:indexPath.row];
        classDict = dict;
        AppDelegateInstance.classId = [classDict safeStringForKey:@"channels_class_id"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshLiveList" object:nil];
    self.typeView.hidden = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (IBAction)closeTypeViewAct:(UIButton *)sender {
    self.typeView.hidden = YES;
}
@end
