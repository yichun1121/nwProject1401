//
//  nwAppDelegate.h
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface nwAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//因為在系統起來的時候會先判斷有沒有Role，如果沒有的話執行預設群組設定，所以需要撈資料來看
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
