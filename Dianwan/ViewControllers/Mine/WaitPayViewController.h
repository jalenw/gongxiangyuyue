//
//  WaitPayViewController.h
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitPayViewController : BaseViewController
@property(nonatomic,strong)NSString *moneryNum;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic)int type;//0购买vip 1购买矿机 2购买课程
@property(nonatomic)NSInteger vipType;
@property(nonatomic,strong)NSString *json;
@property (weak, nonatomic) IBOutlet UIButton *weichatPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuePayBtn;
@end

NS_ASSUME_NONNULL_END
