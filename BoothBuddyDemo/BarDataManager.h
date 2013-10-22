//
//  BarDataManager.h
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BarDataDelegate <NSObject>

- (void)barDataDidLoadFinished;

@optional
- (void)barDataDidLoadFailed:(NSError *)error;

@end

@interface BarDataManager : NSObject

@property (nonatomic, assign) id<BarDataDelegate> delegate;

@property (nonatomic, readonly) NSArray *bars;;

- (void)startLoadDataIfNeed;

@end
