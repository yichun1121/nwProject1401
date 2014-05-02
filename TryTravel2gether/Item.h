//
//  Item.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/1.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip, Group, Receipt;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * itemIndex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) CatInTrip *catInTrip;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Receipt *receipt;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(NSManagedObject *)value;
- (void)removePhotosObject:(NSManagedObject *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
