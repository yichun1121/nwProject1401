//
//  Trip.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip, Currency, Day, Group;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) Currency *mainCurrency;
@property (nonatomic, retain) NSSet *catsInTrip;
@property (nonatomic, retain) NSSet *groups;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

- (void)addCatsInTripObject:(CatInTrip *)value;
- (void)removeCatsInTripObject:(CatInTrip *)value;
- (void)addCatsInTrip:(NSSet *)values;
- (void)removeCatsInTrip:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
