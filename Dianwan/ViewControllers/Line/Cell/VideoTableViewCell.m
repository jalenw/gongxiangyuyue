//
//  VideoTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/4/3.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    self.name.text = [dict safeStringForKey:@"member_name"];
    [self.img sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"cover"]]];
    self.cost.text = [NSString stringWithFormat:@"支付费用:%@",[[dict safeStringForKey:@"price"] integerValue]>0?[NSString stringWithFormat:@"%@元",[dict safeStringForKey:@"price"]]:@"免费"];
    self.content.text = [dict safeStringForKey:@"title"];
}
@end
