//
//  BaseViewController.h
//  ShopFun
//
//  Created by noodle on 30/3/17.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (UIButton*)setRightBarButtonWithTitle:(NSString*)title;
- (UIButton*)setRightBarButtonWithImage:(UIImage*)image;
- (UIButton*)setLeftBarButtonWithImage:(UIImage*)image;
- (void)rightbarButtonDidTap:(UIButton*)button;
- (void)leftbarButtonDidTap:(UIButton*)button;

-(void)back;
-(void)dismiss;
@end
