//
//  SelectAccountOwnerCDTVC.h
//  TryTravel2gether
//
//  Created by apple on 2015/1/17.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"
#import "GuyInTrip.h"
#import "Guy.h"

@class SelectAccountOwnerCDTVC;

@protocol SelectAccountOwnerCDTVCDelegate <NSObject>
-(void)guyWasSelectedInSelectAccountOwnerCDTVC:(SelectAccountOwnerCDTVC *)controller;
@end

@interface SelectAccountOwnerCDTVC : CoreDataTableViewController<NSFetchedResultsControllerDelegate>
@property (strong,nonatomic)id delegate;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic)Trip *currentTrip;
@property (strong,nonatomic)GuyInTrip *selectedGuyInTrip;
@end
