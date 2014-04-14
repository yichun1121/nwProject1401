//
//  Guy.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInTrip;

@interface Guy : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *guyInTrips;
@end

@interface Guy (CoreDataGeneratedAccessors)

- (void)addGuyInTripsObject:(GuyInTrip *)value;
- (void)removeGuyInTripsObject:(GuyInTrip *)value;
- (void)addGuyInTrips:(NSSet *)values;
- (void)removeGuyInTrips:(NSSet *)values;

@end
