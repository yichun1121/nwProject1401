//
//  DaysCDTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "DaysCDTVC.h"
#import "ReceiptsCDTVC.m"
#import "Day+TripDay.h"


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
    //self.tableView.editing=YES;
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
    cell.textLabel.text =[day DayNumberStringOfTripdayInTrip]; //ex:Day 2 or Prepare;
    NSString *strDate=[self.dateFormatter stringFromDate:day.date];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@：%@",strDate,day.name];    //ex:2013/11/29：關西國際機場、高台寺
    
    return cell;
}
/*! 判斷某天是該次旅程的第幾天（startDate當天回傳1，前一天回傳-1，不應該有0） */
-(int)DayNumberOfTripdayInTrip:(Day *)tripDay{
    int result=0;
    NSDateComponents * dateComponents=[[NSDateComponents alloc]init];
    dateComponents=[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:tripDay.inTrip.startDate toDate:tripDay.date options:0];
    if (dateComponents.day>=0) {
        result=dateComponents.day+1;
    }else{
        result=dateComponents.day;
    }
    return result;
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Day *dayToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", dayToDelete.name);
        [self.managedObjectContext deleteObject:dayToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - Segue Settings

// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Add Receipt Segue"]) {
        
        NSLog(@"Setting DaysCDTVC as a delegate of AddReceiptTVC");
        
        AddReceiptTVC *addReceiptTVC = segue.destinationViewController;
        addReceiptTVC.delegate = self;
        
        /*
         已經在AddReceiptTVC裡宣告了一個delegate（是AddReceiptTVCDelegate）
         addReceiptCDTVC.delegate=self的意思是：我要監控AddReceiptTVC
         */
        
        addReceiptTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。
        addReceiptTVC.currentTrip=self.currentTrip;
    }else if([segue.identifier isEqualToString:@"Receipts List Segue"]){
        NSLog(@"Setting DaysCDTVC as a delegate of ReceiptsCDTVC");
        ReceiptsCDTVC *receiptsCDTVC=segue.destinationViewController;
        receiptsCDTVC.managedObjectContext=self.managedObjectContext;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        self.selectedDay = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected Day (%@) to ReceiptsCDTVC", self.selectedDay.name);
        receiptsCDTVC.currentDay=self.selectedDay;
    }else if ([segue.identifier isEqualToString:@"Add Day Segue"]){
        NSLog(@"Setting DaysCDTVC as a delegate of AddDayTVC");
        AddDayTVC *addDayTVC=segue.destinationViewController;
        addDayTVC.delegate=self;
        
        addDayTVC.managedObjectContext=self.managedObjectContext;
        addDayTVC.currentTrip=self.currentTrip;
        
    }
}


#pragma mark - Delegation
-(void)theSaveButtonOnTheAddReceiptWasTapped:(AddReceiptTVC *)controller{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
    
}
-(void)theSaveButtonOnTheAddDayWasTapped:(AddDayTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
