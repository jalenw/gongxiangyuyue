//
//  AlertBuyTableViewCell.h
//  Dianwan
//
//  Created by Yang on 2019/3/17.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AlertBuyTableViewCell;
@protocol JPVPNetEasyTableViewCellDelegate<NSObject>

@optional
- (void)cellPlayButtonDidClick:(AlertBuyTableViewCell *)cell;
- (void)cellDownLoadButtonDidClick:(NSDictionary *)dict;
@end

@interface AlertBuyTableViewCell : UITableViewCell
@property(nonatomic,strong) NSDictionary *dict;
@property(nonatomic,strong)NSString *ossurl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subImageview;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (nonatomic, strong) UIPasteboard *pasteBoard;

@property(nonatomic, weak) id<JPVPNetEasyTableViewCellDelegate> delegate;
- (IBAction)downLoadAct:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
