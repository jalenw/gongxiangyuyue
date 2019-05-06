//
//  MyDemandTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "MyDemandTableViewCell.h"

@implementation MyDemandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.type.text = [dict safeStringForKey:@"cat_name"];
    [self.type sizeToFit];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"cover"]]];
    self.name.text = [dict safeStringForKey:@"title"];
    self.desc.text = [dict safeStringForKey:@"content"];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    self.userName.text = [dict safeStringForKey:@"member_name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
