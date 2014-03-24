//
//  GuyInGroup.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Guy;

@interface GuyInGroup : NSManagedObject

@property (nonatomic, retain) NSSet *guys;
@property (nonatomic, retain) Group *group;
@end

@interface GuyInGroup (CoreDataGeneratedAccessors)

- (void)addGuysObject:(Guy *)value;
- (void)removeGuysObject:(Guy *)value;
- (void)addGuys:(NSSet *)values;
- (void)removeGuys:(NSSet *)values;

@end
