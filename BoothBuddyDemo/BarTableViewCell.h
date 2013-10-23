//
//  BarTableViewCell.h
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/23/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarObject.h"

@interface BarTableViewCell : UITableViewCell

- (void)reloadDataWithBar:(BarObject *)bar;

@end
