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
    self.pasteBoard = [UIPasteboard generalPasteboard];
    self.accountLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
  
//    longPress.numberOfTapsRequired = 1;
    [self.accountLabel addGestureRecognizer:longPress];
    
}

// 使label能够成为响应事件，为了能接收到事件（能成为第一响应者）
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(pasteAction:)) {
        return YES;
    }
//    if (action == @selector(cutAction:)) {
//        return YES;
//    }
    return NO; //隐藏系统默认的菜单项
}
//响应事件
- (void)handleTap:(UILongPressGestureRecognizer *)sender {
    // 防止长按之后连续触发该事件
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
        UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
//      UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, pasteMenueItem, nil]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
    }
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
- (void)copyAction:(id)sender {
    self.pasteBoard.string = self.accountLabel.text;
}

- (void)pasteAction:(id)sender {
    self.accountLabel.text = self.pasteBoard.string;
}
//- (void)cutAction:(id)sender  {
//    self.pasteBoard.string = self.accountLabel.text;
//    self.text = nil;
//}

@end
