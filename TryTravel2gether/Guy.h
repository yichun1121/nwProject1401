//
//  Guy.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInTrip;

@interface Guy : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GuyInTrip *guyInTrips;

@end
