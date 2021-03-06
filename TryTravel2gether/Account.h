//
//  Account.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/19.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuyInTrip, PayWay, Receipt;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * surplus;
@property (nonatomic, retain) NSSet *guysInTrip;
@property (nonatomic, retain) PayWay *payWay;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addGuysInTripObject:(GuyInTrip *)value;
- (void)removeGuysInTripObject:(GuyInTrip *)value;
- (void)addGuysInTrip:(NSSet *)values;
- (void)removeGuysInTrip:(NSSet *)values;

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
