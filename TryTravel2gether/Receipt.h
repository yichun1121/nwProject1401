//
//  Receipt.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/1.
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
@property (nonatomic, retain) NSSet *photos;
@end

@interface Receipt (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addPhotosObject:(NSManagedObject *)value;
- (void)removePhotosObject:(NSManagedObject *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
