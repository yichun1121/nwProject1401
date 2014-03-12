//
//  Currency+CRUD.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Currency.h"

@interface Currency (CRUD)

@property (strong,nonatomic) NSManagedObjectContext * managedObjectContext;
-(Currency *)getWithStandardSign:(NSString *)standardSign;
-(Currency *)newCurrencyWithName:(NSString*)name Sign:(NSString *)sign StandardSign:(NSString *)standardSign;
@end
