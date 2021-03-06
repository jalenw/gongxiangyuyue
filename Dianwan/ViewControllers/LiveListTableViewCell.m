//
//  LiveListTableViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "LiveListTableViewCell.h"

@implementation LiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDict:(NSDictionary *)dict{
    _dict =dict;
    self.viewerCount.text = [NSString stringWithFormat:@"%d人正在观看",[dict safeIntForKey:@"online_num"]];
    self.teacherName.text = [dict safeStringForKey:@"member_name"];
    self.payMethonLabel.text= [dict safeStringForKey:@"member_avatar"];
    [self.coverImageview sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
    [self.teacherImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"member_avatar"]]];
   
    self.titleLabel.text = [dict safeStringForKey:@"channel_title"];
    switch ([dict safeIntForKey:@"channel_status"]) {
        case 0:
            self.typeLabel.text=@"免费直播";
            break;
        case 1:
            self.typeLabel.text=@"余额付费直播";
            break;
        case 2:
            self.typeLabel.text=@"金币付费直播";
            break;
    }
    
}

@end
