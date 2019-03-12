//
//  SystemMsgTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2018/7/31.
//  Copyright © 2018年 intexh. All rights reserved.
//

#import "SystemMsgTableViewCell.h"

@implementation SystemMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForSystemMsgTableViewCell:(NSString*)content
{
    CGFloat height = 66;
    height = height + [Tooles calculateTextHeight:ScreenWidth-16 Content:content fontSize:15];
    return height;
}
@end
