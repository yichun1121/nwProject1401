//
//  Photo.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/9/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Receipt;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * relativePath;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Receipt *receipt;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
