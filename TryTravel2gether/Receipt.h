//
//  Receipt.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, DayCurrency, Item;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Day *day;
@property (nonatomic, retain) DayCurrency *dayCurrency;
@property (nonatomic, retain) NSSet *items;
@end

@interface Receipt (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
