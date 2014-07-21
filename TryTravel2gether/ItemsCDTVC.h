//
//  ItemsCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Receipt.h"
#import "AddItemTVC.h"
#import "ItemDetailTVC.h"

@interface ItemsCDTVC : CoreDataTableViewController<AddItemTVCDelegate,UIPageViewControllerDataSource>
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong,nonatomic) Receipt *currentReceipt;

@property (strong, nonatomic) UIPageViewController *pageViewController; //拿來檢視照片的容器
@end
