//
//  MarketTableViewCell.h
//  Dianwan
//
//  Created by Yang on 2019/3/14.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

NS_ASSUME_NONNULL_END
