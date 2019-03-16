//
//  MarketModel.h
//  Dianwan
//
//  Created by Yang on 2019/3/14.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketModel : NSObject
@property(nonatomic,assign)NSInteger addtime;
@property(nonatomic,assign)NSInteger adv_type;
@property(nonatomic,assign)NSInteger idStr;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger receive;
@property(nonatomic,assign)NSInteger member_id;
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *member_avatar;
@property(nonatomic,strong)NSString *imgs;
@property(nonatomic,strong)NSString *member_name;


@end

NS_ASSUME_NONNULL_END
