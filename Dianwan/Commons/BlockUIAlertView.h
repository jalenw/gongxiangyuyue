//
//  BlockUIAlertView.h
//  Ekeo2
//
//  Created by patrick on 9/7/13.
//  Copyright (c) 2013 Ekeo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView<UIAlertViewDelegate>

@property(nonatomic,copy)AlertBlock block;
@property(nonatomic,assign) BOOL isAlwaysShow;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)block
  otherButtonTitles:(NSString *)otherButtonTitles;

@end
