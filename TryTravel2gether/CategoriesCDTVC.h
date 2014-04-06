//
//  CategoriesCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "AddCategoryTVC.h"

@interface CategoriesCDTVC : CoreDataTableViewController<AddCategoryTVCDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
