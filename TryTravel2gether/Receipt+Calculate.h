//
//  Receipt+Calculate.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/30.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt.h"

@interface Receipt (Calculate)

-(double)calculateSumOfAllItems;
-(double)getMoneyIsNotSet;
-(BOOL)itemsAllSet;
@end
