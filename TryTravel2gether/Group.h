//
//  Group.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInTrip, Item, Trip;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *guysInTrip;
@property (nonatomic, retain) Trip *inTrip;
@property (nonatomic, retain) NSSet *items;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addGuysInTripObject:(GuyInTrip *)value;
- (void)removeGuysInTripObject:(GuyInTrip *)value;
- (void)addGuysInTrip:(NSSet *)values;
- (void)removeGuysInTrip:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
