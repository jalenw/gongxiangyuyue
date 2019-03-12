//
//  NavigationMapViewViewController.m
//  zingchat
//
//  Created by noodle on 15/11/5.
//  Copyright (c) 2015年 Miju. All rights reserved.
//

#import "NavigationMapViewViewController.h"
#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>
#import "MKAnnotation.h"

@interface NavigationMapViewViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager* locManager;
    MKAnnotationView *anView;
}

@end

@implementation NavigationMapViewViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航";
    
    MKAnnotation *naviAnnotation = [[MKAnnotation alloc]init];
    [naviAnnotation setCoordinate:self.naviCoords];
    [self.mapView addAnnotation:naviAnnotation];
    
    self.nowCoords = [LocationService sharedInstance].lastLocation.coordinate;
    
    CLLocationCoordinate2D centerCoor = CLLocationCoordinate2DMake((self.nowCoords.latitude+self.naviCoords.latitude)/2, (self.nowCoords.longitude+self.naviCoords.longitude)/2);
    CGFloat distance = LantitudeLongitudeDist(self.nowCoords.longitude,self.nowCoords.latitude,self.naviCoords.longitude,self.naviCoords.latitude);
    if (distance < 500) {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(centerCoor, 500, 500) animated:YES];
    }else{
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(centerCoor, distance*1.15, distance*1.15) animated:YES];
    }
    self.mapView.showsUserLocation = YES;

    [self drawRout];
    
    [self initLocationManager];
}



-(void)initLocationManager
{
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    if ([locManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locManager performSelector:@selector(requestAlwaysAuthorization)];
    }
    [locManager startUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
        return;
    //个人位置图片根据指向旋转
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    anView.transform = CGAffineTransformMakeRotation(M_PI*2*(theHeading/360));
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.nowCoords = userLocation.coordinate;
    [self drawRout];
 if(LantitudeLongitudeDist(self.nowCoords.longitude,self.nowCoords.latitude,self.naviCoords.longitude,self.naviCoords.latitude) <=30) {
    }
}

-(void)drawRout{
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.nowCoords addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:self.naviCoords addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirectionsFrom:fromItem to:toItem];
}

-(void)findDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error:%@", error);
        }
        else {
            if (response.routes.count > 0) {
                MKRoute *route = response.routes[0];
                [self.mapView addOverlay:route.polyline];
            }
            
        }
    }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        anView= [mapView dequeueReusableAnnotationViewWithIdentifier:@"userAnnotation"];
        if (!anView) {
            anView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotation"];
            anView.frame = CGRectMake(0, 0, 40, 40);
            anView.backgroundColor = [UIColor clearColor];
            UIImageView *powerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myPosition"]];
            powerImageView.center = CGPointMake(anView.width / 2, anView.height / 2);
            [anView addSubview:powerImageView];
        }
        return anView;
    }
    else return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:NO];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        
        MKPolylineView* aView = [[MKPolylineView alloc]initWithOverlay:(MKPolygon*)overlay];
        aView.strokeColor = RGB(0, 182, 255);
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
