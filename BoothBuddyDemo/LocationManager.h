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

/*
 @brief 获取用户当前地点的经纬度信息
 @return  当前用户经纬度信息的CLlocation对象
 */
- (CLLocation *)fetchCurrentLocation;

@end
