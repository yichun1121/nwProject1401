//
//  GuyInTrip+Expend.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuyInTrip.h"
#import "Currency.h"

@interface GuyInTrip (Expend)
-(NSNumber *)totalExpendUsingCurrency:(Currency *)currency;
-(NSString *)totalExpendWithMainCurrencySign;
@end
