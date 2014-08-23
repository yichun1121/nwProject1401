//
//  BackupdataCDTVC.h
//  TryTravel2gether
//
//  Created by vincent on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "nwAppDelegate.h"

@interface BackupdataTVC :UITableViewController<UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *icloudCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *googleDriveCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dropboxCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCSVFileCell;

@property(strong, nonatomic) nwAppDelegate *nwApp;

@end
