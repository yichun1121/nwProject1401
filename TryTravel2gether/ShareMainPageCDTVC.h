//
//  ShareMainPage.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"
#import "SelectTripCDTVC.h"

@interface ShareMainPageCDTVC : CoreDataTableViewController<SelectTripCDTVCDelegate>
@property (weak,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic)Trip *currentTrip;
@end
