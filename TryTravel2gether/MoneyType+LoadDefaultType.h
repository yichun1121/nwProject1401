//
//  MoneyType+LoadDefaultType.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "MoneyType.h"
#import <CoreData/CoreData.h>


@interface MoneyType (LoadDefaultType)

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
//因為在系統起來的時候會先判斷有沒有MoneyType，如果沒有的話執行預設群組設定，所以需要撈資料來看
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)setupFetchedResultsController;
- (void)importCoreDataDefaultMoneyTypes;
@end
