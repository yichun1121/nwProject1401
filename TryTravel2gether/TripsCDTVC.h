//
//  TripsCDTVC.h
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"  // so we can fetch
#import "AddTripTVC.h" // so this class can be a AddTripTVCDelegate
#import "TripDetailTVC.h" // so this class can be an TripDetailTVCDelegate
#import "Trip.h"

@interface TripsCDTVC : CoreDataTableViewController <AddTripTVCDelegate, TripDetailTVCDelegate>
/*  
    TripsTVC繼承UITableViewController（父類別只能有一個）
    後面的括號表示同時俱有AddTripTVCDelegate的功能（也就是會實作Delegate裡面宣告的method，以便在監聽事件觸發後處理）
 */

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// 因為繼承CoreDataTableViewController，所以需要有這兩個property：fetchedResultsController和managedObjectContext

@property (strong, nonatomic) Trip *selectedTrip;   //取出選擇的trip物件，方便傳給Detail頁面

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
