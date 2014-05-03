//
//  Item+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/28.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Item+Expend.h"
#import "Group.h"

@implementation Item (Expend)
-(NSNumber *)sharedPrice{
    double totalPrice=[self.price doubleValue] *[self.quantity doubleValue];
    NSInteger numOfPeople=[self.group.guysInTrip count];
    return [NSNumber numberWithDouble:totalPrice/numOfPeople];
}
@end
