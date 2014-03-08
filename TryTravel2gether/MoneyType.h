//
//  MoneyType.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface MoneyType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sign;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface MoneyType (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
