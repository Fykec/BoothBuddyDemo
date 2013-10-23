//
//  LocationManager.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/23/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *_currentLocation;
}


@end

@implementation LocationManager

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    __strong static id sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
    }
    return self;
}

- (CLLocation *)fetchCurrentLocation
{
    if (_currentLocation != nil)
    {
        return _currentLocation;
    }
    
    [_locationManager startUpdatingLocation];
    return nil;
}

#pragma mark -
#pragma mark CLLocaitonManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    _currentLocation = location;
}

@end
