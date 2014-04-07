//
//  CatInTrip.h
//  TryTravel2gether
//
//  Created by vincent on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Itemcategory, Trip;

@interface CatInTrip : NSManagedObject

@property (nonatomic, retain) Itemcategory *category;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Trip *trip;
@end

@interface CatInTrip (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;


@end
