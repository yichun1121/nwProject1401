//
//  SelectGuysTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Guy.h"
#import "AddGuyTVC.h"


@class SelectGuysCDTVC;
@protocol SelectGuysCDTVCDelegate <NSObject,AddGuyTVCDelegate>
-(void)guyWasSelectedInSelectGuysCDTVC:(SelectGuysCDTVC *)controller;
@end

@interface SelectGuysCDTVC : CoreDataTableViewController<NSFetchedResultsControllerDelegate,UIActionSheetDelegate,AddGuyTVCDelegate>
@property (strong,nonatomic)id delegate;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;



@end