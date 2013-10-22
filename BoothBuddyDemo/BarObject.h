//
//  BarObject.h
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarObject : NSObject

@property (nonatomic, copy) NSString* name;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, retain) NSArray *images;

@end
