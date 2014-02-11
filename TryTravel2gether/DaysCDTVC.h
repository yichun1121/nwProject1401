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
#import "AddDayTVC.h"

@interface DaysCDTVC : CoreDataTableViewController<AddReceiptTVCDelegate,AddDayTVCDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Trip * currentTrip;
@property (strong, nonatomic) Day* selectedDay;

@end
