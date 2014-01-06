//
//  TripsCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripsCDTVC.h"

@implementation TripsCDTVC
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize selectedTrip=_selectedTrip;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Trips Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Trip *trip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = trip.name;
    
    return cell;
}

#pragma mark - Segue Settings

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Add Trip Segue"])
	{
        NSLog(@"Setting TripTVC as a delegate of AddTripTVC");
        
        AddTripCDTVC *addTripCDTVC = segue.destinationViewController;
        addTripCDTVC.delegate = self;
        /*
            已經在AddTripCDTVC裡宣告了一個delegate（是AddTripCDTVCDelegate）
            addTripCDTVC.delegate=self的意思是：我要監控AddTripCDTVC
         */
        
        addTripCDTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
	}else if ([segue.identifier isEqualToString:@"Trip Detail Segue"])
    {
        NSLog(@"Setting TripsCDTVC as a delegate of TripDetailCDTVC");
        TripDetailCDTVC *tripDetailCDTVC = segue.destinationViewController;
        tripDetailCDTVC.delegate = self;
         //TripTVC.delegate=self的意思是：我要監控TripDetailCDTVC
        tripDetailCDTVC.managedObjectContext = self.managedObjectContext;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        self.selectedTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected trip (%@) to TripDetailCDTVC", self.selectedTrip.name);
        tripDetailCDTVC.trip = self.selectedTrip;
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

#pragma mark - Delegation
/*
    .h檔案宣告時有@interface TripsTVC : UITableViewController <AddTripTVCDelegate>
    就要實作AddTripTVCDelegate宣告的method
 */
- (void)theSaveButtonOnTheAddTripTVCWasTapped:(AddTripCDTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

-(void)theSaveButtonOnTheTripDetailCDTVCWasTapped:(TripDetailCDTVC *)controller{
    
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Trip"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}

#pragma mark - Deleting
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Trip *tripToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", tripToDelete.name);
        [self.managedObjectContext deleteObject:tripToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
}

@end
