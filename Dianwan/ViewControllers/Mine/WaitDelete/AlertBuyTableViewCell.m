//
//  AlertBuyTableViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/17.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "AlertBuyTableViewCell.h"

@implementation AlertBuyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
//    _dict=@{
//                @"id": @(1),
//                @"order_sn": @"19030810554827723381",
//                @"courses_goods_name": @"课程名称",
//                @"courses_price": @"200",
//                @"courses_goods_image": @"home/store/goods/1/oss_1_2019030616474396580.jpg",
//                @"courses_skydrive_link": @"http://www.baidu.com",
//                @"courses_skydrive_code": @(4),
//                @"order_state": @"0",
//                @"store_id": @(23),
//                @"member_id": @(10381),
//                @"pay_time": @"2019-03-08",
//                @"courses_goods_id": @(4),
//                @"member_name": @"222"
//                };
    self.titleLabel.text = [_dict safeStringForKey:@"courses_goods_name"];
    self.subtitleLabel.text = [_dict safeStringForKey:@"courses_goods_name"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[_dict safeStringForKey:@"courses_goods_image"]]];
    [self.subImageview sd_setImageWithURL:[NSURL URLWithString:[_dict safeStringForKey:@"courses_goods_image"]]];
    
    
    self.accountLabel.text = [_dict safeStringForKey:@"courses_skydrive_link"];
    
    self.pwLabel.text = [_dict safeStringForKey:@"courses_skydrive_code"];
}

@end
