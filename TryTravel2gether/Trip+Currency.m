//
//  Trip+Currency.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/4.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Trip+Currency.h"
#import "Day.h"
#import "DayCurrency.h"

@implementation Trip (Currency)

-(NSOrderedSet *)getAllCurrencies{
    NSMutableOrderedSet * currenciesSet=[NSMutableOrderedSet new];
    [currenciesSet addObject:self.mainCurrency];
    for (Day *day in self.days) {
        for (DayCurrency * dayCurrency in day.dayCurrencies) {
            [currenciesSet addObject:dayCurrency.currency];
        }
    }
    return [[NSOrderedSet alloc]initWithOrderedSet:currenciesSet];
}
@end
