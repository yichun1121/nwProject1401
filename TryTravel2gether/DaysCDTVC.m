//
//  DaysCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "DaysCDTVC.h"

@interface DaysCDTVC ()
@property NSDateFormatter *dateFormatter;
@end

@implementation DaysCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentTrip=_currentTrip;
@synthesize dateFormatter=_dateFormatter;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    //self.fetchedResultsController=self.currentTrip.days;
    // 1 - Decide what Entity you want
    NSString *entityName = @"Day"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=self.currentTrip.name;
    
    self.dateFormatter=[[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Day Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *dayString=[NSString stringWithFormat:@"Day %@",day.dayIndex]; //ex:Day 2
    cell.textLabel.text =dayString;
    cell.detailTextLabel.text=[self.dateFormatter stringFromDate:day.date];  //([day.name isEqualToString:dayString]?@"":day.name);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
