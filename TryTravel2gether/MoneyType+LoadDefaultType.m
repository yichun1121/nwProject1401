//
//  MoneyType+LoadDefaultType.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/8.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "MoneyType+LoadDefaultType.h"

@implementation MoneyType (LoadDefaultType)
@dynamic fetchedResultsController;
@dynamic managedObjectContext;

#pragma mark - 直接用名稱和符號新增一個MoneyType
- (void)insertMoneyWithTypeName:(NSString *)moneyTypeName useMoneySign:(NSString *)moneySign standardMoneySign:(NSString *)standardSign
{
    MoneyType *type = [NSEntityDescription insertNewObjectForEntityForName:@"MoneyType"
                                               inManagedObjectContext:self.managedObjectContext];
    
    type.name = moneyTypeName;
    type.sign=moneySign;
    type.standardSign=standardSign;
    
    [self.managedObjectContext save:nil];
}

#pragma mark - 為了default data而預先撈出來的資料
- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"MoneyType"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Person.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
}


#pragma mark - 創建預設的Role群組寫在這裡
- (void)importCoreDataDefaultMoneyTypes {
    
    NSLog(@"Importing Core Data Default Values for Roles...");
    [self insertMoneyWithTypeName:@"Taiwan Dollar" useMoneySign:@"NT" standardMoneySign:@"TWD"];
    [self insertMoneyWithTypeName:@"Japanese Yen" useMoneySign:@"￥" standardMoneySign:@"JPY"];
    NSLog(@"Importing Core Data Default Values for Roles Completed!");
}



@end
