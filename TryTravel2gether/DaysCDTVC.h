//
//  DaysCDTVC.h
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "Day.h"
#import "CoreDataTableViewController.h"
#import "AddReceiptTVC.h"

@interface DaysCDTVC : CoreDataTableViewController<AddReceiptTVCDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Trip * currentTrip;
@property (strong, nonatomic) Day* selectedDay;

@end
