//
//  Day.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayMoneyType, Receipt, Trip;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dayIndex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Trip *inTrip;
@property (nonatomic, retain) NSSet *receipts;
@property (nonatomic, retain) NSSet *dayCurrency;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

- (void)addDayCurrencyObject:(DayMoneyType *)value;
- (void)removeDayCurrencyObject:(DayMoneyType *)value;
- (void)addDayCurrency:(NSSet *)values;
- (void)removeDayCurrency:(NSSet *)values;

@end
