//
//  DayCurrency.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Currency, Receipt;

@interface DayCurrency : NSManagedObject

@property (nonatomic, retain) Currency *currency;
@property (nonatomic, retain) Day *tripDay;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface DayCurrency (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
