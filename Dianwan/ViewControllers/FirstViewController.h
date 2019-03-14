//
//  FirstViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/8/1.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "BaseViewController.h"
#import "AdView.h"
#import "SliderMenuView.h"
@interface FirstViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet AdView *adView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *cashLb;
@property (weak, nonatomic) IBOutlet UILabel *rewardLb;
@property (weak, nonatomic) IBOutlet SliderMenuView *smView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@end
