//
//  GuysCDTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"  // so we can fetch
#import "AddGuyTVC.h" // so this class can be a AddGuyTVCDelegate
#import "Guy.h"

@interface GuysCDTVC : CoreDataTableViewController <AddGuyTVCDelegate,UIGestureRecognizerDelegate>
/*
 GuysTVC繼承UITableViewController（父類別只能有一個）
 後面的括號表示同時俱有AddGuyTVCDelegate的功能（也就是會實作Delegate裡面宣告的method，以便在監聽事件觸發後處理）
 */

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// 因為繼承CoreDataTableViewController，所以需要有這兩個property：fetchedResultsController和managedObjectContext

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
