//
//  UINavigationItem+SXFixSpace.m
//  UINavigationItem-SXFixSpace
//
//  Created by charles on 2017/9/8.
//  Copyright © 2017年 None. All rights reserved.
//

#import "UINavigationItem+SXFixSpace.h"
#import "NSObject+SXRuntime.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SXBarViewPosition) {
    SXBarViewPositionLeft,
    SXBarViewPositionRight
};

@interface BarView : UIView
@property (nonatomic, assign) SXBarViewPosition position;
@property (nonatomic, assign) BOOL applied;
@end

@implementation BarView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.applied || [[[UIDevice currentDevice] systemVersion] floatValue]  < 11) return;
    UIView *view = self;
    while (![view isKindOfClass:UINavigationBar.class] && view.superview) {
        view = [view superview];
        if ([view isKindOfClass:UIStackView.class] && view.superview) {
            if (self.position == SXBarViewPositionLeft) {
                for (NSLayoutConstraint *constraint in view.superview.constraints) {
                    if (([constraint.firstItem isKindOfClass:UILayoutGuide.class] &&
                         constraint.firstAttribute == NSLayoutAttributeTrailing)) {
                        [view.superview removeConstraint:constraint];
                    }
                }
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:view.superview
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1.0
                                                                            constant:0]];
                self.applied = YES;
            } else if (self.position == SXBarViewPositionRight) {
                for (NSLayoutConstraint *constraint in view.superview.constraints) {
                    if (([constraint.firstItem isKindOfClass:UILayoutGuide.class] &&
                         constraint.firstAttribute == NSLayoutAttributeLeading)) {
                        [view.superview removeConstraint:constraint];
                    }
                }
                [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:view.superview
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1.0
                                                                            constant:0]];
                self.applied = YES;
            }
            break;
        }
    }
}

@end

@implementation UINavigationItem (SXFixSpace)

//+(void)load {
//    [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItem:)
//                                 swizzledSel:@selector(sx_setLeftBarButtonItem:)];
//    [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:)
//                                 swizzledSel:@selector(sx_setRightBarButtonItem:)];
//}

-(void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    if (leftBarButtonItem.customView) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
            UIView *customView = leftBarButtonItem.customView;
            BarView *barView = [[BarView alloc]initWithFrame:customView.bounds];
            [barView addSubview:customView];
            customView.center = barView.center;
            [barView setPosition:SXBarViewPositionLeft];
            [self setLeftBarButtonItems:nil];
            [self setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:barView]];
        }else {
            [self setLeftBarButtonItem:nil];
            [self setLeftBarButtonItems:@[[self fixedSpaceWithWidth:-20], leftBarButtonItem]];
        }
    }else {
        [self setLeftBarButtonItems:nil];
        [self setLeftBarButtonItem:leftBarButtonItem];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (rightBarButtonItem.customView) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
            UIView *customView = rightBarButtonItem.customView;
            BarView *barView = [[BarView alloc]initWithFrame:customView.bounds];
            [barView addSubview:customView];
            customView.center = barView.center;
            [barView setPosition:SXBarViewPositionRight];
            [self setRightBarButtonItems:nil];
            [self setRightBarButtonItems:@[[[UIBarButtonItem alloc]initWithCustomView:barView]]];
        } else {
            [self setRightBarButtonItems:nil];
            [self setRightBarButtonItems:@[[self fixedSpaceWithWidth:-20], rightBarButtonItem]];
        }
    }else {
        [self setRightBarButtonItems:nil];
        [self setRightBarButtonItems:@[rightBarButtonItem]];
    }
}

- (void)sx_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (UIBarButtonItem *rightBarButtonItem in rightBarButtonItems) {
        if (rightBarButtonItem.customView) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
                UIView *customView = rightBarButtonItem.customView;
                BarView *barView = [[BarView alloc]initWithFrame:customView.bounds];
                [barView addSubview:customView];
                customView.center = barView.center;
                [barView setPosition:SXBarViewPositionRight];
                [array addObject:[[UIBarButtonItem alloc]initWithCustomView:barView]];
            } else {
                [array addObject:rightBarButtonItem];
            }
        }else {
            [array addObject:rightBarButtonItem];
        }
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 11) {
        [array insertObject:[self fixedSpaceWithWidth:-20] atIndex:0];
    }
    [self setRightBarButtonItems:nil];
    [self setRightBarButtonItems:array];
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
