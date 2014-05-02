//
//  Photo.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/1.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Receipt;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fullPath;
@property (nonatomic, retain) NSSet *receipts;
@property (nonatomic, retain) NSSet *items;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
