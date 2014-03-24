//
//  Guy.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInGroup;

@interface Guy : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GuyInGroup *guyInGroups;

@end
