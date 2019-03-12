//
//  MKAnnotation.h
//  zingchat
//
//  Created by noodle on 16/4/15.
//  Copyright © 2016年 Miju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MKAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;
    NSString* _title;
    NSString* _subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
