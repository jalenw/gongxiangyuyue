//
//  PreviewTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/7.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "PreviewTableViewCell.h"

@implementation PreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    self.name.text = [dict safeStringForKey:@"member_name"];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"cover"]]];
    self.title.text = [dict safeStringForKey:@"title"];
    [self.title sizeToFit];
    self.type.text = [dict safeStringForKey:@"class_name"];
    [self.type sizeToFit];
    self.type.left = self.title.right+8;
    self.time.text = [NSString stringWithFormat:@"直播时间:%@", [dict safeStringForKey:@"channel_time"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
