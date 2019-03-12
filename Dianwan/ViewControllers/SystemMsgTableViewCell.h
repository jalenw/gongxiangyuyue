//
//  SystemMsgTableViewCell.h
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/31.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
+(CGFloat)heightForSystemMsgTableViewCell:(NSString*)content;
@end
