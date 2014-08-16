//
//  Account.h
//  TryTravel2gether
//
//  Created by apple on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Receipt;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *receipts;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(Receipt *)value;
- (void)removeReceiptsObject:(Receipt *)value;
- (void)addReceipts:(NSSet *)values;
- (void)removeReceipts:(NSSet *)values;

@end
