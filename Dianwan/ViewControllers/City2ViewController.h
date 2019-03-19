//
//  City2ViewController.h
//  BaseProject
//
//  Created by Mac on 2018/11/17.
//  Copyright © 2018年 ZNH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "cityModel.h"
@interface City2ViewController : BaseViewController
-(instancetype)initWithcity_id:(NSNumber *)area_id;
@property(nonatomic,copy)void(^cityBlock)(cityModel * model);
@end
