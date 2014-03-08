//
//  ReceiptsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ReceiptsCDTVC.h"

@interface ReceiptsCDTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@end

@implementation ReceiptsCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentDay=_currentDay;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Receipt";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate=[NSPredicate predicateWithFormat:@"day=%@",self.currentDay];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                                                    ascending:YES
                                                                                     selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [self performFetch];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=self.currentDay.name;
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Receipt Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Receipt *receipt=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=receipt.desc;
    // TODO....幣別符號
    NSString *moneyTypeSign=@"￥";
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",moneyTypeSign,receipt.total];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"Add Receipt Segue From Receipts"]) {
        NSLog(@"Setting ReceiptsCDTVC as a delegate of AddReceiptTVC");
        AddReceiptTVC *addReceiptTVC=segue.destinationViewController;
        addReceiptTVC.delegate=self;
        addReceiptTVC.managedObjectContext=self.managedObjectContext;
        addReceiptTVC.currentTrip=self.currentDay.inTrip;
        //addReceiptTVC.selectedDayString=[self.dateFormatter stringFromDate:self.currentDay.date];
    }
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Receipt *receiptDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@(%@)", receiptDelete.desc,receiptDelete.total);
        [self.managedObjectContext deleteObject:receiptDelete];
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

#pragma mark - delegation
-(void)theSaveButtonOnTheAddReceiptWasTapped:(AddReceiptTVC *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
