//
//  CategoriesCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CategoriesCDTVC : CoreDataTableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
