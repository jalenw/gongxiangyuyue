//
//  NavigationMapViewViewController.h
//  zingchat
//
//  Created by noodle on 15/11/5.
//  Copyright (c) 2015年 Miju. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface NavigationMapViewViewController : BaseViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,assign) CLLocationCoordinate2D naviCoords;//目的地位置
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;//个人位置

@end
