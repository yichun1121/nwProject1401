//
//  Receipt+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/10/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt+Expend.h"
#import "Item.h"
#import "Item+Expend.h"
@implementation Receipt (Expend)
-(NSNumber *)allItemExpend{
    double total=0;
    for (Item *item in self.items) {
        total=[item.totalPrice doubleValue]+total;
    }
    return [NSNumber numberWithDouble:total];
}
@end
