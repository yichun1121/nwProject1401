//
//  Receipt.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) NSManagedObject *moneyType;

@end
