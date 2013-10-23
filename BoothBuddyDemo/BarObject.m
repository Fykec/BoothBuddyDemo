//
//  BarObject.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "BarObject.h"
#import "BarAPIConst.h"

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
        bar.longitude = [[jsonDic objectForKey:@"longitude"] floatValue];
        
        NSMutableArray *pics = [NSMutableArray array];
        for (NSString *picSuffix in [jsonDic objectForKey:@"pictures"])
        {
            [pics addObject:[NSString stringWithFormat:@"%@%@", BAR_IMAGE_API_PATH_PREFIX, picSuffix]];
        }
        bar.images = pics;
        
        bar.minimalPrice = [[jsonDic objectForKey:@"minimal_price"] floatValue];
        return bar;
    }
    
    return nil;
}

@end
