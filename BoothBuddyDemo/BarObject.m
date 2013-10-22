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

+ (BarObject *)objectFromJsonDic:(NSDictionary *)jsonDic
{
    if (jsonDic && [[jsonDic allKeys] count] > 0)
    {
        BarObject *bar = [[BarObject alloc] init];
        bar.name = [jsonDic objectForKey:@"name"];
        bar.latitude = [[jsonDic objectForKey:@"latitude"] floatValue];
        bar.images = [jsonDic objectForKey:@"pictures"];
        bar.minimalPrice = [[jsonDic objectForKey:@"minimal_price"] floatValue];
        return bar;
    }
    
    return nil;
}

@end
