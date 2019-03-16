//
//  LiveListTableViewCell.h
//  Dianwan
//
//  Created by Yang on 2019/3/15.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIImageView *teacherImageView;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageview;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMethonLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewerCount;


@end

NS_ASSUME_NONNULL_END
