//
//  MarketTableViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/14.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "MarketTableViewCell.h"

@implementation MarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)setModel:(MarketModel *)model{
//    _model = model;
//}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.headImageview sd_setImageWithURL:[NSURL URLWithString: [dict safeStringForKey:@"member_avatar"]]];
    self.titleLabel.text = [dict safeStringForKey:@"title"];
    self.subtitleLabel.text = [dict safeStringForKey:@"content"];
    self.nameLabel.text = [dict safeStringForKey:@"member_name"];
    @try {
          [self.coverImageview sd_setImageWithURL:[NSURL URLWithString:[dict safeStringForKey:@"imgs"]]];
    } @catch (NSException *exception) {
        [self.coverImageview sd_setImageWithURL:[NSURL URLWithString:[dict safeArrayForKey:@"imgs"][0]]];
    } @finally {
        NSLog(@"正常解析图像");
    }
  
    self.countLabel.text = [NSString stringWithFormat:@"%d /%d",[dict safeIntForKey:@"receive"],[dict safeIntForKey:@"num"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


@end
