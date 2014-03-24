//
//  CatInTrip.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Item, Trip;

@interface CatInTrip : NSManagedObject

@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSSet *items;
@end

@interface CatInTrip (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
