//
//  GuyInTrip.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Guy, Trip;

@interface GuyInTrip : NSManagedObject

@property (nonatomic, retain) NSNumber * realInTrip;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) NSSet *guy;
@property (nonatomic, retain) Trip *inTrip;
@end

@interface GuyInTrip (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addGuyObject:(Guy *)value;
- (void)removeGuyObject:(Guy *)value;
- (void)addGuy:(NSSet *)values;
- (void)removeGuy:(NSSet *)values;

@end
