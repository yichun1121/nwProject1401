//
//  GuyInTrip+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuyInTrip+Expend.h"
#import "Trip.h"
#import "Group.h"
#import "Item.h"
#import "Receipt.h"
#import "DayCurrency.h"
#import "Item+Expend.h"
@implementation GuyInTrip (Expend)
-(NSNumber * )totalExpendUsingCurrency:(Currency *)currency{
    double total=0;
    //TODO:未完成的全程花費邏輯
    for (Group *inGroup in self.groups) {
        for (Item * item in inGroup.items) {
            if (item.receipt.dayCurrency.currency!=currency) {
                break;
            }else {
                total+=[item.sharedPrice doubleValue];
            }
        }
    }
    return [NSNumber numberWithDouble:total];
}
-(NSString *)totalExpendWithMainCurrencySign{
    Currency *currency=self.inTrip.mainCurrency;
    return [NSString stringWithFormat:@"%@ %@",currency.sign,[self totalExpendUsingCurrency:currency]];
}
@end
