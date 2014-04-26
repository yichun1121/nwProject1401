//
//  GuyInTrip+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuyInTrip+Expend.h"
#import "Trip.h"

@implementation GuyInTrip (Expend)
-(NSNumber *)totalExpendUsingCurrency:(Currency *)currency{
    //TODO:未完成的全程花費邏輯
    return [NSNumber numberWithDouble:1300];
}
-(NSString *)totalExpendWithMainCurrencySign{
    Currency *currency=self.inTrip.mainCurrency;
    return [NSString stringWithFormat:@"%@ %@",currency.sign,[self totalExpendUsingCurrency:currency]];
    //TODO:未完成的主要貨幣花費邏輯
}
@end
