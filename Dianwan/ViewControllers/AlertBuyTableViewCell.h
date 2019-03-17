//
//  AlertBuyTableViewCell.h
//  Dianwan
//
//  Created by Yang on 2019/3/17.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertBuyTableViewCell : UITableViewCell
@property(nonatomic,strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImageview;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;

@end

NS_ASSUME_NONNULL_END
