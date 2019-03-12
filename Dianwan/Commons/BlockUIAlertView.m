//
//  BlockUIAlertView.m
//  Ekeo2
//
//  Created by patrick on 9/7/13.
//  Copyright (c) 2013 Ekeo. All rights reserved.
//

#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

- (id)initWithTitle:(NSString *)title
message:(NSString *)message
cancelButtonTitle:(NSString *)cancelButtonTitle
clickButton:(AlertBlock)block
otherButtonTitles:(NSString *)otherButtonTitles {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    if (self) {
        self.block = block;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.block(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.isAlwaysShow) {
        self.delegate = self;
        [self show];
    }
}

@end
