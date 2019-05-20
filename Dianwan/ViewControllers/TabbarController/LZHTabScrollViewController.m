//
//  LZHTabScrollViewController.m
//  kuxing
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHTabScrollViewController.h"

@interface LZHTabScrollViewController ()<UIScrollViewDelegate>

@end

@implementation LZHTabScrollViewController

- (void)dealloc{
    self.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTapScroll];
}

- (NSArray<NSString*>*)buttonTitleArray{
    
    return @[];
}

- (void)setupControllers{
    
}

- (CGFloat)topHeaderWidth{
    return 44;
}

- (UIView*)createTopHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    return view;
}

- (CGFloat)indicatorOffset{
    return (self.topHeaderView.width/self.topButtonArray.count-80)/2;
}

- (BOOL)isAllowScroll{
    return YES;
}

- (UIColor*)normalTabTextColor{
    return [UIColor blackColor];
}

- (UIColor*)selectTabTextColor{
    return [UIColor whiteColor];
}

- (UIColor*)indicatorColor{
    return ThemeColor;
}


- (CGFloat)indicatorTop{
    return  self.topHeaderView.height-2;
}

- (void)currentControllerDidChange{
    
}

-(CGFloat)indicatorWidth{
    return   self.topHeaderView.width/[self buttonTitleArray].count-[self indicatorOffset]*2;
}

- (BOOL)currentControllerShouldChangeWithIndex:(NSInteger)index{
    return YES;
}

- (void)setupTapScroll{
    if (self.topHeaderView) {
        [self.topHeaderView removeFromSuperview];
    }
    self.topHeaderView = [self createTopHeaderView];
    
    NSArray *buttonTitles = [self buttonTitleArray];
    NSMutableArray *tempButtonArray = [[NSMutableArray alloc] init];
    CGFloat buttonWidth = self.topHeaderView.width/buttonTitles.count;
    if ([self isAllowScroll]) {
        if(buttonWidth < 70){
            buttonWidth = 70;
            self.topHeaderView.width = 70*buttonTitles.count;
        }
    }
    
    for (int i = 0; i < buttonTitles.count; ++i) {
        NSString *buttonTitle = buttonTitles[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*i, 0, buttonWidth, self.topHeaderView.height)];
        button.tag = 100+i;
        button.backgroundColor =[self BtnbackgroundColor];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[self normalTabTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[self selectTabTextColor] forState:UIControlStateSelected];
        button.titleLabel.font = DefaultFontOfSize(16);
        if(ScreenWidth < 375)
        {
             button.titleLabel.font = DefaultFontOfSize(11);
        }
        [button addTarget:self action:@selector(topButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [tempButtonArray addObject:button];
        [self.topHeaderView addSubview:button];
        if (i == 0) {
            button.selected = YES;
        }
    }
    
    self.topButtonArray = [NSArray arrayWithArray:tempButtonArray];
//    self.topHeaderView.width/buttonTitles.count-[self indicatorOffset]*2--修改长度
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake([self indicatorOffset], [self indicatorTop], [self indicatorWidth], 2)];
    self.indicatorView.backgroundColor = [self indicatorColor];
    [self.topHeaderView addSubview:self.indicatorView];
    
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.contentSize = CGSizeMake(ScreenWidth*self.topButtonArray.count, 0);
        [self.view insertSubview:self.scrollView atIndex:0];
    }
    
    
    [self setupControllers];
}

- (void)topButtonDidTap:(UIButton*)button{
    NSInteger index = button.tag-100;
    if ([self currentControllerShouldChangeWithIndex:index] == NO) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    CGFloat topHeaderWidth = [self topHeaderWidth];
    if (topHeaderWidth == 0) {
        topHeaderWidth = self.topHeaderView.width;
    }
    
    
    CGFloat buttonWidth = topHeaderWidth/self.topButtonArray.count;
    CGFloat indicatorOffset = [self indicatorOffset];
    CGFloat indicatorTop =[self indicatorTop];
    
    NSInteger controllerCount = self.controllerArray.count;
    
    for (int i = 0; i < controllerCount; ++i) {
        if (self.controllerArray.count > i) {
            UIViewController *controller = self.controllerArray[i];
            if (self.currentController == controller) {
                if (scrollView.contentOffset.x <= scrollView.width*(i-1)) {
                    id preController = nil;
                    for (int j = 0; j < self.controllerArray.count; ++j) {
                        id scrollVC = self.controllerArray[j];
                        UIButton *tapButton = self.topButtonArray[j];
                        if (j == i-1) {
                            tapButton.selected = YES;
                            preController = scrollVC;
                            if ([scrollVC respondsToSelector:@selector(tableView)]) {
                                UITableView *tableView = [scrollVC tableView];
                                tableView.scrollsToTop = YES;
                            }
                            
                        }else{
                            tapButton.selected = NO;
                            if ([scrollVC respondsToSelector:@selector(tableView)]) {
                                UITableView *tableView = [scrollVC tableView];
                                tableView.scrollsToTop = NO;
                            }
                        }
                    }
                    self.indicatorView.frame = CGRectMake(indicatorOffset+buttonWidth*(i-1), indicatorTop, (buttonWidth-indicatorOffset*2)+buttonWidth, 2);
                    [UIView animateWithDuration:0.275 animations:^{
                        self.indicatorView.frame = CGRectMake(indicatorOffset+buttonWidth*(i-1), indicatorTop, (buttonWidth-indicatorOffset*2), 2);
                    }];
                    if (self.currentController != preController) {
                        self.currentController = preController;
                        [self currentControllerDidChange];
                    }
                    
                    
                }else if (scrollView.contentOffset.x < scrollView.width*i){
                    CGFloat moveScale = (scrollView.contentOffset.x-scrollView.width*i)/scrollView.width;
                    self.indicatorView.frame = CGRectMake(moveScale*buttonWidth+buttonWidth*i+indicatorOffset, indicatorTop, (buttonWidth-indicatorOffset*2)-(moveScale*buttonWidth), 2);
                }else if (scrollView.contentOffset.x < scrollView.width*(i+1)){
                    CGFloat moveScale = (scrollView.contentOffset.x-scrollView.width*i)/scrollView.width;
                    self.indicatorView.frame = CGRectMake(buttonWidth*i+indicatorOffset, indicatorTop, (buttonWidth-indicatorOffset*2)+(moveScale*buttonWidth), 2);
                }else{
                    id nextController = nil;
                    for (int j = 0; j < self.controllerArray.count; ++j) {
                        id scrollVC = self.controllerArray[j];
                        UIButton *tapButton = self.topButtonArray[j];
                        if (j == i+1) {
                            tapButton.selected = YES;
                            nextController = scrollVC;
                            if ([scrollVC respondsToSelector:@selector(tableView)]) {
                                UITableView *tableView = [scrollVC tableView];
                                tableView.scrollsToTop = YES;
                            }
                        }else{
                            tapButton.selected = NO;
                            if ([scrollVC respondsToSelector:@selector(tableView)]) {
                                UITableView *tableView = [scrollVC tableView];
                                tableView.scrollsToTop = NO;
                            }
                        }
                    }
                    self.indicatorView.frame = CGRectMake(indicatorOffset+buttonWidth*i, indicatorTop, (buttonWidth-indicatorOffset*2)+buttonWidth, 2);
                    [UIView animateWithDuration:0.275 animations:^{
                        self.indicatorView.frame = CGRectMake(indicatorOffset+buttonWidth*(i+1), indicatorTop, (buttonWidth-indicatorOffset*2), 2);
                    }];
                    if (self.currentController != nextController) {
                        self.currentController = nextController;
                        [self currentControllerDidChange];
                    }
                    
                }
            }
        }
    }
    
    
    if (self.topHeadScrollView) {
        CGFloat targetLeft = 0;
        targetLeft = self.indicatorView.left;
        
        if ((targetLeft < self.topHeadScrollView.contentOffset.x) || (targetLeft+self.indicatorView.width > self.topHeadScrollView.contentOffset.x+self.topHeadScrollView.width)) {
            
            if (targetLeft < 0) {
                targetLeft = 0;
            }
            
            if (targetLeft+self.topHeadScrollView.width > self.topHeadScrollView.contentSize.width) {
                targetLeft = self.topHeadScrollView.contentSize.width-self.topHeadScrollView.width;
            }
            
            self.topHeadScrollView.contentOffset = CGPointMake(targetLeft, 0);
            
        }
        
        
    }
    
    _lastOffsetX = scrollView.contentOffset.x;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.showControllerAtIndexWhenAppear) {
        int index = [self.showControllerAtIndexWhenAppear intValue];
        [self.scrollView setContentOffset:CGPointMake(index*ScreenWidth, 0) animated:YES];
        self.showControllerAtIndexWhenAppear = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
