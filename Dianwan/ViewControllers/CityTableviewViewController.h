//
//  CityTableviewViewController.h
//  BaseProject
//
//  Created by Mac on 2018/11/12.
//  Copyright © 2018年 ZNH. All rights reserved.
//


#import "BaseViewController.h"

#import "cityModel.h"

@interface CityTableviewViewController : BaseViewController
@property(nonatomic,copy)void(^cityBlock)(cityModel * model);
@end
