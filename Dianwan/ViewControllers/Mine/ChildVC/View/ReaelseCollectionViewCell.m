//
//  ReaelseCollectionViewCell.m
//  Dianwan
//
//  Created by Yang on 2019/3/16.
//  Copyright © 2019 intexh. All rights reserved.
//

#import "ReaelseCollectionViewCell.h"

@implementation ReaelseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCoverImage:(UIImage *)coverImage{
    _coverImage = coverImage;
 [self.coverImageview setImage:_coverImage];

   
}

@end
