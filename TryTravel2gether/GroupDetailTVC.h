//
//  GroupDetailTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/5/7.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Group.h"
#import "SelectGuysCDTVC.h"
#import "NWAdShiftTableViewController.h"

@class GroupDetailTVC;

@protocol GroupDetailTVCDelegate<NSObject>
- (void)theSaveButtonOnTheGroupDetailTVCWasTapped:(GroupDetailTVC *)controller;
@end

@interface GroupDetailTVC : NWAdShiftTableViewController<NSFetchedResultsControllerDelegate,SelectGuysCDTVCDelegate>

@property (nonatomic, weak) id <GroupDetailTVCDelegate>delegate;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *
fetchedResultsController;

@property (nonatomic, strong)Group *group;


- (IBAction)save:(id)sender;


@end
