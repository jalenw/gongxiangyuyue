//
//  LiveMsgTableViewCell.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/20.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
+(CGFloat)heightForLiveMsgTableViewCell:(EMMessage*)message;
@end

NS_ASSUME_NONNULL_END
