//
//  LZHActionSheetView.m
//  kuxing
//
//  Created by mac on 17/3/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LZHActionSheetView.h"

@interface LZHActionSheetView()
{
    
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *actionButtons;

@end


@implementation LZHActionSheetView

+ (instancetype)createWithTitleArray:(NSArray *)array{
    LZHActionSheetView *view = [[LZHActionSheetView alloc] initWithFrame:ScreenBounds];
    view->_actionTitleArray = array;
    [view setup];
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)setup{
    
    self.frame = ScreenBounds;
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    UIButton *maskButton = [[UIButton alloc] initWithFrame:ScreenBounds];
    [maskButton addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskButton];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth-16, 100)];
    self.containerView.backgroundColor = [UIColor clearColor];
    
    CGFloat actionHeight = 50;
    UIColor *actionTitleColor = DarkColor2;
    UIImage *selectBackImage = [Tooles createImageWithColor:RGBA(0, 0, 0, 0.1)];
    UIView *actionContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.width, actionHeight*self.actionTitleArray.count)];
    actionContainerView.backgroundColor = [UIColor whiteColor];
    actionContainerView.clipsToBounds = YES;
    actionContainerView.layer.cornerRadius = 8;
    
    self.actionButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.actionTitleArray.count; ++i) {
        NSString *string = self.actionTitleArray[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, actionHeight*i, actionContainerView.width, actionHeight)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(actionDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:actionTitleColor forState:UIControlStateNormal];
        [button setTitleColor:GrayColor2 forState:UIControlStateDisabled];
        [button setBackgroundImage:selectBackImage forState:UIControlStateHighlighted];
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, button.width, 1)];
        sepView.backgroundColor = GrayColor1;
        [button addSubview:sepView];
        [actionContainerView addSubview:button];
        [self.actionButtons addObject:button];
    }
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, actionContainerView.height+8, self.containerView.width, actionHeight)];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 8;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:actionTitleColor forState:UIControlStateNormal];
    [button setBackgroundImage:selectBackImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(cancelDidTap:) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;
    _cancelButton = button;
    
    self.containerView.height = _cancelButton.bottom+8;
    self.containerView.top = self.height;
    [self addSubview:self.containerView];
    [self.containerView addSubview:actionContainerView];
    [self.containerView addSubview:self.cancelButton];
    
    
}

- (NSArray*)getActionButtons{
    return self.actionButtons;
}


- (void)show{
    [AppDelegateInstance.window addSubview:self];
    [UIView animateWithDuration:0.275 animations:^{
        _containerView.bottom = self.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.275 animations:^{
        _containerView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)actionDidTap:(UIButton*)button{
    NSInteger index = button.tag-100;
    if (self.block) {
        self.block(index, button.titleLabel.text);
    }
    [self hide];
    
}

- (void)cancelDidTap:(UIButton*)button{
    [self hide];
    if (self.block) {
        self.block(-1, button.titleLabel.text);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
