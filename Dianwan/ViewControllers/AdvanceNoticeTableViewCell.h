//
//  AdvanceNoticeTableViewCell.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvanceNoticeTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *type;
@end

NS_ASSUME_NONNULL_END
