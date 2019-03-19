//
//  MyDigTableViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MyDigTableViewCell.h"

@implementation MyDigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"mine_machine_image"]]];
    self.titleLabel.text = [dict safeStringForKey:@"mine_machine_name"];
    self.cionNumLabel.text = [NSString stringWithFormat:@"%d枚",[dict safeIntForKey:@"bonus_number"]];
    self.remainingLabel.text =[dict safeStringForKey:@"remainingTime"];//[NSString stringWithFormat:@"剩余%d天",[dict safeIntForKey:@"remainingTime"]];
    NSString *type;
    switch ([dict safeIntForKey:@"mine_type"]) {
        case 0:
            type = @"未开始";
            break;
        case 1:
            type = @"工作中";
            break;
        case 2:
             type = @"已结束";
            break;
            
        default:
            break;
    }
    if([dict safeIntForKey:@"settlement_state"]== 0){
        self.TypeLabel.hidden = NO;
    }
    self.typeLabel.text =type;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
