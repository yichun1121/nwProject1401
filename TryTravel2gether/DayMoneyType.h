//
//  DayMoneyType.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, MoneyType, Receipt;

@interface DayMoneyType : NSManagedObject

@property (nonatomic, retain) MoneyType *moneyType;
@property (nonatomic, retain) Day *tripDay;
@property (nonatomic, retain) Receipt *receipts;

@end
