//
//  PreviewDetailViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/5/6.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

@interface PreviewDetailViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

