//
//  Receipt.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, DayMoneyType;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) DayMoneyType *dayMoneyType;

@end
