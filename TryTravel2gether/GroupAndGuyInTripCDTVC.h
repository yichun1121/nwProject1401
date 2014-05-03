//
//  GroupAndGuyInTripCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Trip.h"
#import "AddGroupTVC.h"

@class GroupAndGuyInTripCDTVC;
@protocol GroupAndGuyInTripCDTVCDelegate <NSObject>
-(void)groupListCheckedInGroupAndGuyInTripCDTVC:(GroupAndGuyInTripCDTVC *)controller;
@end

@interface GroupAndGuyInTripCDTVC : CoreDataTableViewController<AddGroupTVCDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic)id<GroupAndGuyInTripCDTVCDelegate> delegate;

@property Trip *currentTrip;

@end
