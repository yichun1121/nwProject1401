//
//  NWAdShiftTableViewController.m
//  TryTravel2gether
//
//  Created by vincent on 2014/7/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWAdShiftTableViewController.h"

@interface NWAdShiftTableViewController ()

@end

@implementation NWAdShiftTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - Table view set AdMob banner
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //-----self.tableView.frame 的高度剪掉AdMob Banner高度-------(讓Banner不會擋到TableView的資訊)
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x
                                        , self.tableView.frame.origin.y
                                        , self.tableView.frame.size.width
                                        , self.tableView.frame.size.height-50)];
}

@end
