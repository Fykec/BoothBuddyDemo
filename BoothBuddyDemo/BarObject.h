//
//  BarObject.h
//  BoothBuddyDemo
//
//  Created by Foster Yin on 10/22/13.
//  Copyright (c) 2013 Foster Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarObject : NSObject

/*
 ####酒吧名字
 */
@property (nonatomic, copy) NSString* name;

/*
 ####酒吧地点的纬度
 */
@property (nonatomic, assign) CGFloat latitude;

/*
 ####酒吧地点的经度
 */
@property (nonatomic, assign) CGFloat longitude;

/*
 ####酒吧消费最低金额
 */
@property (nonatomic, assign) CGFloat minimalPrice;

/*
 ####酒吧环境的图片
 */
@property (nonatomic, retain) NSArray *images;

/*
 @brief parse json成BarObject。
 @param jsonDic， json的数据
 @return  返回BarObject对象
 */
+ (BarObject *)objectFromJsonDic:(NSDictionary *)jsonDic;

@end
