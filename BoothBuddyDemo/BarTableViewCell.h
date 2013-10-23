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

/*
 @brief 根据酒吧信息刷新cell的视图
 @param bar， 酒吧的信息
 */
- (void)reloadDataWithBar:(BarObject *)bar;

@end
