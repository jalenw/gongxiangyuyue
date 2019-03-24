//
//  ClassDetailViewController.h
//  Dianwan
//
//  Created by 黄哲麟 on 2019/3/24.
//  Copyright © 2019年 intexh. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailViewController : BaseViewController
@property (nonatomic,strong) NSString *classId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
- (IBAction)playAct:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
