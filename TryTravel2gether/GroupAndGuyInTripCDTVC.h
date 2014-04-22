//
//  GroupAndGuyInTripCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"

@interface GroupAndGuyInTripCDTVC : CoreDataTableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;


@property Trip *currentTrip;
@property Group *selectedGroup;

@end
