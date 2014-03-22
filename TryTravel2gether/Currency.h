//
//  Currency.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayCurrency, Trip;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sign;
@property (nonatomic, retain) NSString * standardSign;
@property (nonatomic, retain) NSSet *dayCurrency;
@property (nonatomic, retain) NSSet *trips;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addDayCurrencyObject:(DayCurrency *)value;
- (void)removeDayCurrencyObject:(DayCurrency *)value;
- (void)addDayCurrency:(NSSet *)values;
- (void)removeDayCurrency:(NSSet *)values;

- (void)addTripsObject:(Trip *)value;
- (void)removeTripsObject:(Trip *)value;
- (void)addTrips:(NSSet *)values;
- (void)removeTrips:(NSSet *)values;

@end
