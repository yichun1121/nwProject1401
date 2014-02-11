//
//  ReceiptsCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Day.h"
#import "Receipt.h"

@interface ReceiptsCDTVC : CoreDataTableViewController<AddReceiptTVCDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) Day *currentDay;
@property (strong,nonatomic) Receipt *selectedReceipt;

@end
