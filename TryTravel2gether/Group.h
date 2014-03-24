//
//  Group.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInGroup, Item, Trip;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *guysInGroup;
@property (nonatomic, retain) Trip *inTrip;
@property (nonatomic, retain) NSSet *items;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addGuysInGroupObject:(GuyInGroup *)value;
- (void)removeGuysInGroupObject:(GuyInGroup *)value;
- (void)addGuysInGroup:(NSSet *)values;
- (void)removeGuysInGroup:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
