//
//  nwAppDelegate.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "nwAppDelegate.h"
#import "TripsCDTVC.h"
#import "Currency.h"
#import "Itemcategory.h"
#import "SettingMenuRVC.h"
#import "ShareMainPageCDTVC.h"

@implementation nwAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//撈資料用的
@synthesize fetchedResultsController=__fetchedResultsController;

#pragma mark - 4. 塞值：配合3傳入的資料新增一個物件
- (void)insertMoneyWithTypeName:(NSString *)moneyTypeName useMoneySign:(NSString *)moneySign standardMoneySign:(NSString *)standardSign
{
    Currency *currency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency"
                                                    inManagedObjectContext:self.managedObjectContext];
    currency.name = moneyTypeName;
    currency.sign=moneySign;
    currency.standardSign=standardSign;
    [self.managedObjectContext save:nil];
}
- (void)insertCategoryName:(NSString *)categoryName WithDecimalColor:(NSString*)decimalColor IconName:(NSString *)iconName
{
    Itemcategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Itemcategory"
                                                       inManagedObjectContext:self.managedObjectContext];
    category.name = categoryName;
    category.colorRGB=decimalColor;
    if ([@""isEqualToString:iconName]) {
        category.iconName=nil;
    }else{
        category.iconName=iconName;
    }
    [self.managedObjectContext save:nil];
}

#pragma mark - 2. 先撈出來看需不需要載入default資料
- (void)setupFetchedResultsControllerByEntityName:(NSString*)entityName AttributeName:(NSString*)attributeName
{
    // 1 - Decide what Entity you want
    //NSString *entityName = @"MoneyType"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Person.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - 3. Default Data：創建預設的資訊寫在這裡一個一個設定
- (void)importCoreDataDefaultMoneyTypes {
    
    NSLog(@"Importing Core Data Default Values for Currencies...");
//    [self insertMoneyWithTypeName:@"Taiwan Dollar" useMoneySign:@"NT" standardMoneySign:@"TWD"];
//    [self insertMoneyWithTypeName:@"Japanese Yen" useMoneySign:@"￥" standardMoneySign:@"JPY"];
//    [self insertMoneyWithTypeName:@"U.S.Dollar" useMoneySign:@"＄" standardMoneySign:@"USD"];
    NSString *readPlist=[[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"];
    NSArray *arrCurrency=[NSArray arrayWithContentsOfFile:readPlist];
    for (int i=0; i<arrCurrency.count; i++) {
        NSString *name=[[arrCurrency objectAtIndex:i] objectForKey:@"currencyName"];
        NSString *sign=[[arrCurrency objectAtIndex:i] objectForKey:@"currencySign"];
        NSString *standarSign=[[arrCurrency objectAtIndex:i] objectForKey:@"currencyStandardSign"];
        [self insertMoneyWithTypeName:name useMoneySign:sign standardMoneySign:standarSign];
    }
    NSLog(@"Importing Core Data Default Values for Currencies Completed!");
}
- (void)importCoreDataDefaultCategories {
    
    NSLog(@"Importing Core Data Default Values for Item Categories...");
    NSString *readPlist=[[NSBundle mainBundle] pathForResource:@"ItemCategory" ofType:@"plist"];
    NSArray *arrCategory=[NSArray arrayWithContentsOfFile:readPlist];
    for (int i=0; i<arrCategory.count; i++) {
        NSString *name=[[arrCategory objectAtIndex:i] objectForKey:@"itemCategoryName"];
        NSString *iconName=[[arrCategory objectAtIndex:i] objectForKey:@"iconName"];
        NSString *hexColorRGB=[[arrCategory objectAtIndex:i] objectForKey:@"hexColorRGB"];
        int red, green, blue;
        sscanf([hexColorRGB UTF8String], "%02X%02X%02X", &red, &green, &blue);
        NSString *decimalColorRGB=[NSString stringWithFormat:@"%i%i%i",red,green,blue];
        [self insertCategoryName:name WithDecimalColor:decimalColorRGB IconName:iconName];
    }

    NSLog(@"Importing Core Data Default Values for Item Categories Completed!");
}

-(void)checkDefaultData:(NSString *)entityName By:(NSString *)attributeName{
    [self setupFetchedResultsControllerByEntityName:entityName AttributeName:attributeName];
    
    if (![[self.fetchedResultsController fetchedObjects] count] > 0 ) {
        NSLog(@"!!!!! ~~> There's no %@ in the database so defaults will be inserted",entityName);
        if ([@"Currency" isEqualToString:entityName]) {
            [self importCoreDataDefaultMoneyTypes];
        }else if ([@"Itemcategory" isEqualToString:entityName]){
            [self importCoreDataDefaultCategories];
        }
    }
    else {
        NSLog(@"There's %@ in the database so skipping the import of default data",entityName);
    }
}
#pragma mark - 1. 在這判斷是否要載入default資訊
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     要設定Default Data的話加這段>
     系統起來的時候會檢查有沒有Role存在，沒有的話就把預設的Role存進去
     */
    [self checkDefaultData:@"Currency" By:@"name"];
    [self checkDefaultData:@"Itemcategory" By:@"name"];
//    [self setupFetchedResultsControllerByEntityName:@"Currency" AttributeName:@"name"];
//    
//    if (![[self.fetchedResultsController fetchedObjects] count] > 0 ) {
//        NSLog(@"!!!!! ~~> There's no Currency in the database so defaults will be inserted");
//        [self importCoreDataDefaultMoneyTypes];
//    }
//    else {
//        NSLog(@"There's stuff in the database so skipping the import of default data");
//    }
//
//    //Uncategorized
//    [self setupFetchedResultsControllerByEntityName:@"Itemcategory" AttributeName:@"name"];
//    
//    if (![[self.fetchedResultsController fetchedObjects] count] > 0 ) {
//        NSLog(@"!!!!! ~~> There's no Itemcategory in the database so defaults will be inserted");
//        [self importCoreDataDefaultCategories];
//    }
//    else {
//        NSLog(@"There's stuff in the database so skipping the import of default data");
//    }

    
    // Override point for customization after application launch.
    ////-------這是第一版還沒加sidebar menu的時候由uinavigationController進入實用的--------------
    //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //TripsCDTVC *controller = (TripsCDTVC *)navigationController.topViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    ////-------這是第二版，由SWRevealViewController進入時用的--------------------
    //SettingMenuRVC *settingMenuRVC=(SettingMenuRVC *)self.window.rootViewController;
    //settingMenuRVC.managedObjectContext=self.managedObjectContext;
    //-------這是第三版，由tabBarController進入時使用---------------------
    UITabBarController *tabBarController=(UITabBarController *)self.window.rootViewController;
    SettingMenuRVC *settingMenuRVC=(SettingMenuRVC *) tabBarController.viewControllers[0];
    settingMenuRVC.managedObjectContext=self.managedObjectContext;
    
    UINavigationController *navigationControllerToShare=(UINavigationController *)tabBarController.viewControllers[1];
    if ([navigationControllerToShare.topViewController isKindOfClass:[ShareMainPageCDTVC class]]) {
        ShareMainPageCDTVC *shareMainPageCDTVC=(ShareMainPageCDTVC *)navigationControllerToShare.topViewController;
        shareMainPageCDTVC.managedObjectContext=self.managedObjectContext;
    }
    
    
//    SWRevealViewController *revelViewController=(SWRevealViewController *)self.window.rootViewController;
//    UINavigationController *navigationController = (UINavigationController *)revelViewController.frontViewController;
//    TripsCDTVC *controller=(TripsCDTVC *)navigationController.topViewController;
//    controller.managedObjectContext=self.managedObjectContext;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
