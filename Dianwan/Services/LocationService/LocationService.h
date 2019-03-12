//
//  LocationService.h
//  Miju
//
//  Created by patrick on 12/10/13.
//  Copyright (c) 2013 Miju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject
@property (nonatomic , strong) CLLocation *prevLocation;
@property (nonatomic , strong) CLLocation* lastLocation;
@property (assign,nonatomic) BOOL isBackground;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) NSString *lastCity;
@property (nonatomic, strong) NSString *lastProvince;

+ (LocationService *)sharedInstance;
- (void)startUpdateLocation;
- (void)startMonitoringSignificantLocationChanges;
- (void)stopUpdateLocation;
- (void)stopMonitoringSignificantLocationChanges;
- (void)updateLocationManually;
- (NSArray*)getUploadedLocations;
- (void)clearUploadedLocations;
@end
