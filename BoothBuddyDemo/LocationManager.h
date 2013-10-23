//
//  LocationManager.h
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/23/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationManager : NSObject

+ (id)sharedInstance;

- (CLLocation *)fetchCurrentLocation;

@end
