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
    
    self.digCountLabel.text = [NSString stringWithFormat:@"预售结束时间:%@",[dict safeStringForKey:@"advance_end_time"]];
     self.timeLabel.text = [NSString stringWithFormat:@"开始产币时间:%@",[dict safeStringForKey:@"advance_end_time"]];
    [self.bt setTitle:[NSString stringWithFormat:@"购买(￥%@)",[dict safeStringForKey:@"mine_machine_price"]] forState:UIControlStateNormal];
    self.sellLb.text = [NSString stringWithFormat:@"已售%@",[[dict safeStringForKey:@"order_count"] integerValue]>0?[dict safeStringForKey:@"order_count"]:@"0"];
    
    self.lb1.text = [NSString stringWithFormat:@"日产币%@",[dict safeStringForKey:@"coin_num"]];
    [self.lb1 sizeToFit];
    self.lb1.width += 6;
    self.lb2.left = self.lb1.right+5;
    self.lb2.text = [NSString stringWithFormat:@"时长%@天",[dict safeStringForKey:@"production_day"]];
    [self.lb2 sizeToFit];
    self.lb2.width += 6;
    self.lb3.left = self.lb2.right+5;
    self.lb3.text = [NSString stringWithFormat:@"%@",[dict safeStringForKey:@"class_name"]];
    [self.lb3 sizeToFit];
    self.lb3.width += 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
