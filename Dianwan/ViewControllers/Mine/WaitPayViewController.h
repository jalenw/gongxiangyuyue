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
@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)NSString *moneryNum;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic)int type;//1购买矿机 2购买课程 3购买视频 4购买直播 5租赁身份 6金币商品 7普通商品
@property(nonatomic)NSInteger payType;
@property(nonatomic,strong)NSString *json;
@property (weak, nonatomic) IBOutlet UIButton *weichatPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuePayBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIView *aliView;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@end

NS_ASSUME_NONNULL_END
