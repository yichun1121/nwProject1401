//
//  Itemcategory.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/5/1.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip;

@interface Itemcategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * colorRGB;
@property (nonatomic, retain) NSString * iconName;
@property (nonatomic, retain) NSSet *catInTrips;
@end

@interface Itemcategory (CoreDataGeneratedAccessors)

- (void)addCatInTripsObject:(CatInTrip *)value;
- (void)removeCatInTripsObject:(CatInTrip *)value;
- (void)addCatInTrips:(NSSet *)values;
- (void)removeCatInTrips:(NSSet *)values;

@end
