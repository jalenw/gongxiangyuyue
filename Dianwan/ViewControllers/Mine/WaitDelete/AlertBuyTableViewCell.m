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
    self.titleLabel.text = [_dict safeStringForKey:@"courses_goods_name"];
    self.subtitleLabel.text = [_dict safeStringForKey:@"courses_goods_name"];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.ossurl,[_dict safeStringForKey:@"courses_goods_image"]]]];
    [self.subImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.ossurl,[_dict safeStringForKey:@"courses_goods_image"]]]];
    
    
    self.accountLabel.text = [_dict safeStringForKey:@"courses_skydrive_link"];
    
    self.pwLabel.text =[NSString stringWithFormat:@"%@",[_dict safeNumberForKey:@"courses_skydrive_code"]];
}

@end
