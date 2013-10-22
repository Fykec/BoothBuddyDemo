//
//  BarDataManager.m
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import "BarDataManager.h"
#import "BarObject.h"

#import <SBJson.h>


@interface BarDataManager ()

{
    NSArray *_bars;
}

@end

@implementation BarDataManager
@synthesize bars = _bars;

- (void)startLoadDataIfNeed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       NSHTTPURLResponse *response = nil;
                       NSError *error = nil;
                       NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.boothbuddy.com/api/1/bar/search"]] returningResponse:&response error:&error];
                       
                       if (response && [response statusCode] == 200 && data && [data length] > 0)
                       {
                           NSObject * jsonObj = [[[SBJsonParser alloc] init] objectWithData:data];
                           if ([jsonObj isKindOfClass:[NSDictionary class]])
                           {
                               NSDictionary *jsonDic = (NSDictionary *)jsonObj;
                               if ([[jsonDic objectForKey:@"msg"] isEqualToString:@"ok"])
                               {
                                   NSArray *jsonArr = [jsonDic objectForKey:@"val"];
                                   NSMutableArray *barArray = [[NSMutableArray alloc] init];
                                   
                                   for (NSDictionary *barJsonDic in jsonArr)
                                   {
                                       BarObject *bar = [BarObject objectFromJsonDic:barJsonDic];
                                       if (bar)
                                       {
                                           [barArray addObject:bar];
                                       }
                                   }
                                   
                                   _bars = barArray;
                                   
                               }
                               
                           }
                           
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          if (error)
                                          {
                                              if (self.delegate && [self.delegate respondsToSelector:@selector(barDataDidLoadFailed:)])
                                              {
                                                  [self.delegate barDataDidLoadFailed:error];
                                              }
                                          }
                                          
                                          if (_bars && [_bars count] > 0)
                                          {
                                              if (self.delegate && [self.delegate respondsToSelector:@selector(barDataDidLoadFinished)])
                                              {
                                                  [self.delegate barDataDidLoadFinished];
                                              }
                                          }
                                          
                                          
                                          
                                      });
                   });
}

@end
