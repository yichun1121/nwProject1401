//
//  MoneyType.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayMoneyType;

@interface MoneyType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sign;
@property (nonatomic, retain) NSString * standardSign;
@property (nonatomic, retain) NSSet *dayMoneyType;
@end

@interface MoneyType (CoreDataGeneratedAccessors)

- (void)addDayMoneyTypeObject:(DayMoneyType *)value;
- (void)removeDayMoneyTypeObject:(DayMoneyType *)value;
- (void)addDayMoneyType:(NSSet *)values;
- (void)removeDayMoneyType:(NSSet *)values;

@end
