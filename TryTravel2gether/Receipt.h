//
//  Receipt.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/9/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Day, DayCurrency, Item, Photo;

@interface Receipt : NSManagedObject

@property (nonatomic, retain) id calculatorArray;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Account *account;
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

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
