//
//  FirstViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "AdView.h"
@interface FirstViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet AdView *adView;
@end
