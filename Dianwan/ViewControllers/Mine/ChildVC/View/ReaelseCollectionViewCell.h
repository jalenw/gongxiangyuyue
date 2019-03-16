//
//  ReaelseCollectionViewCell.h
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReaelseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)  UIImage *coverImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageview;
@end

NS_ASSUME_NONNULL_END
