//
//  TripDaysCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"

@class TripDaysCDTVC;
@protocol TripDaysCDTVCDelegate <NSObject>
-(void)dayWasSelectedInTripDaysCDTVC:(TripDaysCDTVC *)controller;
@end

@interface TripDaysCDTVC : CoreDataTableViewController
@property (weak,nonatomic)id delegate;

@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic)NSString *selectedDayString;
@property (strong,nonatomic)Trip *currentTrip;
@end
