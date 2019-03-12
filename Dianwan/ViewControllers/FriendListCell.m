//
//  FriendListCell.m
//  Dianwan
//
//  Created by intexh on 2017/7/22.
//  Copyright © 2017年 intexh. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 17;
    self.image.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
