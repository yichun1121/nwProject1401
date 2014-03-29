//
//  TripDaysTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"

@class TripDaysTVC;
@protocol TripDaysTVCDelegate <NSObject>
-(void)dayWasSelectedInTripDaysTVC:(TripDaysTVC *)controller;
@end

@interface TripDaysTVC : UITableViewController<NSFetchedResultsControllerDelegate>
@property (strong,nonatomic)id delegate;


@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic)NSString *selectedDayString;
@property (strong,nonatomic)Trip *currentTrip;
@end
