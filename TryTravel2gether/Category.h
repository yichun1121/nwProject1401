//
//  Category.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CatInTrip;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *catInTrips;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addCatInTripsObject:(CatInTrip *)value;
- (void)removeCatInTripsObject:(CatInTrip *)value;
- (void)addCatInTrips:(NSSet *)values;
- (void)removeCatInTrips:(NSSet *)values;

@end
