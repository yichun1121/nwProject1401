//
//  OwnItemsCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Trip.h"

@interface OwnItemsCDTVC :CoreDataTableViewController
@property (strong,nonatomic) NSSet *userGroups;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
