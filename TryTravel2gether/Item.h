//
//  Item.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip, Group, Receipt;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * itemIndex;
@property (nonatomic, retain) CatInTrip *catInTrip;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Receipt *receipt;

@end
