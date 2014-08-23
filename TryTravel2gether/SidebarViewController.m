//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SettingMenuRVC.h"
#import "CoreDataTableViewController.h"
#import "TripsCDTVC.h"
#import "CategoriesCDTVC.h"
#import "GuysCDTVC.h"
#import "BackupdataTVC.h"
#import "ExportCSVFileCDTVC.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

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

    menuItems = @[@"title", @"trips", @"categories", @"guys",@"backupdata",@"exportData"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //因為storyboard上面都已經有拉好的trips,categories,guys的cell，所以用dequeueReusableCellWithIdentifier可以把這些cell找出來show
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    //destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        
        if ([segue.identifier isEqualToString:@"Trip List Segue From Sidebar Menu"]) {
            TripsCDTVC *tripsCDTVC=segue.destinationViewController;
            tripsCDTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"Translate managedObjectContext to TripsCDTVC @%@",self.class);
        }else if ([segue.identifier isEqualToString:@"Category List Segue From Sidebar Menu"]){
            CategoriesCDTVC *categoriesCDTVC=segue.destinationViewController;
            categoriesCDTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"Translate managedObjectContext to CategoriesCDTVC @%@",self.class);
        }else if ([segue.identifier isEqualToString:@"Guy List Segue From Sidebar Menu"]){
            GuysCDTVC *guysCDTVC=segue.destinationViewController;
            guysCDTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"Translate managedObjectContext to GuysCDTVC @%@",self.class);
        }else if ([segue.identifier isEqualToString:@"Backupdata List Segue From Sidebar Menu"]){
            BackupdataTVC *backupdataTVC=segue.destinationViewController;
            backupdataTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"Translate managedObjectContext to BackupdataTVC @%@",self.class);
        }else if ([segue.identifier isEqualToString:@"Exportdata List Segue From Sidebar Menu"]){
            ExportCSVFileCDTVC *exportCSVFileCDTVC=segue.destinationViewController;
            exportCSVFileCDTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"Translate managedObjectContext to ExportdataCDTVC @%@",self.class);
        }
        
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}
@end
