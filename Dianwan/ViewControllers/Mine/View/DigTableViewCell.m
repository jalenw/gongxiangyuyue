//
//  DigTableViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/14.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "DigTableViewCell.h"

@implementation DigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"mine_machine_image"]]];
    self.titleLabel.text = [dict safeStringForKey:@"mine_machine_name"];
    self.digCountLabel.text = [NSString stringWithFormat:@"日产币%d枚",[dict safeIntForKey:@"coin_num"]];
     self.timeLabel.text = [NSString stringWithFormat:@"时长%d天",[dict safeIntForKey:@"production_day"]];
    self.moneryLabel.text = [NSString stringWithFormat:@"¥%d",[dict safeIntForKey:@"mine_machine_price"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
