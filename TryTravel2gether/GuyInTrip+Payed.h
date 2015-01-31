//
//  GuyInTrip+Payed.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "GuyInTrip.h"
#import "Currency.h"
@interface GuyInTrip (Payed)

-(NSNumber *)totalPayedUsingCurrency:(Currency *)currency;
-(NSString *)totalPayedWithMainCurrencySign;
@end
