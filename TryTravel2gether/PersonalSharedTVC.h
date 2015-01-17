//
//  PersonalSharedTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/17.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuyInTrip.h"

@interface PersonalSharedTVC : UITableViewController

@property (weak,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) GuyInTrip* currentGuy;
@end
