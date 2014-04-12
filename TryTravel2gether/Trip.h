//
//  Trip.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip, Currency, Day, Group, GuyInTrip;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *catsInTrip;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) Currency *mainCurrency;
@property (nonatomic, retain) NSSet *guysInTrip;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addCatsInTripObject:(CatInTrip *)value;
- (void)removeCatsInTripObject:(CatInTrip *)value;
- (void)addCatsInTrip:(NSSet *)values;
- (void)removeCatsInTrip:(NSSet *)values;

- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addGuysInTripObject:(GuyInTrip *)value;
- (void)removeGuysInTripObject:(GuyInTrip *)value;
- (void)addGuysInTrip:(NSSet *)values;
- (void)removeGuysInTrip:(NSSet *)values;

@end
