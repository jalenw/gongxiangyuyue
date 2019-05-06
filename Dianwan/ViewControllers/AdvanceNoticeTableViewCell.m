//
//  AdvanceNoticeTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/4.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "AdvanceNoticeTableViewCell.h"

@implementation AdvanceNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"cover"]]];
    self.name.text = [dict safeStringForKey:@"title"];
    self.type.text = [dict safeStringForKey:@"class_name"];
    self.desc.text = [NSString stringWithFormat:@"直播时间:%@", [dict safeStringForKey:@"channel_time"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
