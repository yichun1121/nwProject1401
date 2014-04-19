//
//  GuysInTripCDTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "GuyInTrip.h"
#import "SelectGuysCDTVC.h"
#import "Trip.h"
#import "Guy.h"
#import "Group.h"

@class GuysInTripCDTVC;
@protocol GuysInTripCDTVCDelegate <NSObject>
-(void)guyWasSelectedInGuysInTripCDTVC:(GuysInTripCDTVC *)controller;
@end

@interface GuysInTripCDTVC : CoreDataTableViewController<NSFetchedResultsControllerDelegate,UIActionSheetDelegate,SelectGuysCDTVCDelegate>
@property (strong,nonatomic)id delegate;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic)NSMutableSet *SelectedGuys;
@property (strong,nonatomic)Trip *currentTrip;
- (IBAction)done:(id)sender;
@end
