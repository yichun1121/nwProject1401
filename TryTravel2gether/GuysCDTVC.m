//
//  GuysCDTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuysCDTVC.h"
#import "SWRevealViewController.h"

@implementation GuysCDTVC

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    //------Set Sidebar Menu--------
    [self setSidebarMenuAction];
    
}
-(void)setSidebarMenuAction{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Guy"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:NO
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Guys Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    Guy *guy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = guy.name;
    return cell;
}

#pragma mark - ➤ Navigation：Segue Settings

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Add Guy Segue From Guy List"])
	{
        NSLog(@"Setting GuyCDTVC as a delegate of AddGuyTVC");
        
        AddGuyTVC *addGuyTVC = segue.destinationViewController;
        addGuyTVC.delegate = self;
        /*
         已經在AddTripCDTVC裡宣告了一個delegate（是AddTripCDTVCDelegate）
         addTripCDTVC.delegate=self的意思是：我要監控AddTripCDTVC
         */
        
        addGuyTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
	}
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

#pragma mark - Deleting
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Guy *guyToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", guyToDelete.name);
        [self.managedObjectContext deleteObject:guyToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

#pragma mark - Delegation
/*
 .h檔案宣告時有@interface GuysTVC : UITableViewController <AddGuyTVCDelegate>
 就要實作AddGuyTVCDelegate宣告的method
 */
-(void)theSaveButtonOnTheAddGuyWasTapped:(AddGuyTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
