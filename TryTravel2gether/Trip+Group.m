//
//  Trip+Group.m
//  TryTravel2gether
//
//  Created by apple on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip+Group.h"
#import "Group.h"

@implementation Trip (Group)

-(NSNumber *)countRealGroups{
    int count=0;
    for (Group *group in self.groups) {
        if ([group.guysInTrip count]>1) {
            count++;
        }
    }
    return [NSNumber numberWithInt:count];
}

@end
