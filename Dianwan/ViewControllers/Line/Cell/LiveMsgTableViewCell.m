//
//  LiveMsgTableViewCell.m
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/20.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "LiveMsgTableViewCell.h"

@implementation LiveMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForLiveMsgTableViewCell:(EMMessage*)message
{
    CGFloat height = 21;
    EMTextMessageBody *body = message.messageBodies.firstObject;
    NSString *text = body.text;
    NSDictionary *dict = [Tooles stringToJson:text];
    NSString *string = [NSString stringWithFormat:@"%@:%@",[dict safeStringForKey:@"nickName"],[dict safeStringForKey:@"content"]];
    height += [Tooles calculateTextHeight:ScreenWidth-32 Content:string fontSize:16];
    return height;
}
@end
