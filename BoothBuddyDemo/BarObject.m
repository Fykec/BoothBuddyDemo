//
//  BarObject.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "BarObject.h"

@implementation BarObject

- (void)dealloc
{
    self.name = nil;
    self.images = nil;
}

@end
