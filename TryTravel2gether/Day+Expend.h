//
//  Day+Expend.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Day.h"
#import "DayCurrency.h"

@interface Day (Expend)

-(NSNumber *)dayExpendUsing:(Currency *)currency;
-(NSNumber *)dayExpendUsingMainCurrency;
@end
