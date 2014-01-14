//
//  Day.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trip;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dayIndex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Trip *inTrip;

@end
