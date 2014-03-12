//
//  Trip.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Currency, Day;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) Currency *mainCurrency;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
