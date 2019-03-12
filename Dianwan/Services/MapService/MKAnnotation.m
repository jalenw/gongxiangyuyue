//
//  MKAnnotation.m
//  zingchat
//
//  Created by noodle on 16/4/15.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import "MKAnnotation.h"

@implementation MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (NSString*)title
{
    return _title;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (NSString*)subtitle
{
    return _subtitle;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
}

@end
