//
//  Day.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayCurrency, Receipt, Trip;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dayIndex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dayCurrencies;
@property (nonatomic, retain) Trip *inTrip;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addDayCurrenciesObject:(DayCurrency *)value;
- (void)removeDayCurrenciesObject:(DayCurrency *)value;
- (void)addDayCurrencies:(NSSet *)values;
- (void)removeDayCurrencies:(NSSet *)values;

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
