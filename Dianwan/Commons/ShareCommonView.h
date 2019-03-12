//
//  ShareCommonView.h
//  zingchat
//
//  Created by index on 16/12/26.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

typedef void(^ShareCommonViewBlock)(NSInteger index);

@interface ShareCommonView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) SSDKShareStateChangedHandler shareBlock;
@property (nonatomic, strong) NSMutableDictionary *shareParam;
@property (nonatomic, strong) ShareCommonViewBlock block;



@end
