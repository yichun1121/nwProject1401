//
//  ReceiptsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ReceiptsCDTVC.h"
#import "DayCurrency.h"
#import "Currency.h"
#import "ReceiptDetailTVC.h"
#import "ItemsCDTVC.h"
#import "Day+TripDay.h"
#import "Receipt+Calculate.h"
#import "NWCustCellReceipt.h"

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
    
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
    
    //-----設定頁面標題------
    if ([@""isEqualToString:self.currentDay.name]) {
        NSString *strDate=[self.dateFormatter stringFromDate:self.currentDay.date];
        NSString *shortDate=[strDate substringFromIndex:5];
        self.navigationItem.title=[NSString stringWithFormat:@"%@ %@",shortDate,self.currentDay.DayNumberStringOfTripdayInTrip];
    }else{
        self.navigationItem.title=self.currentDay.name;
    }
    
    //-----註冊CustomCell----------
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellReceipt" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    
    //-----設定下一頁時的back button的字（避免本頁的title太長）-----------
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBackString_Receipts", @"NavigationBackString") style:UIBarButtonItemStylePlain target:nil action:nil];

}

#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Cell";
    NWCustCellReceipt *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellReceipt alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(NWCustCellReceipt *)configureCell:(NWCustCellReceipt *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    Receipt *receipt=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextLabel.text=receipt.desc;
    if ([receipt isItemsGroupAllSet]) {
        cell.alertSignGroup.hidden=YES;
    }else{
        cell.alertSignGroup.hidden=NO;
    }
    
    NSString *moneyTypeSign=receipt.dayCurrency.currency.sign;
    cell.detailLabel.text=[
                           NSString stringWithFormat:@"%@ %@",moneyTypeSign,receipt.total];
    //    if ([[receipt calculateSumOfAllItems]isEqualToNumber: receipt.total]) {
    if ([receipt isItemsAllSet]) {        
        cell.alertSignExpend.hidden=YES;
    }else {
        cell.alertSignExpend.hidden=NO;
    }
    
    if (!receipt.account) {
        cell.alertSignAccount.hidden=NO;
        //TODO: 付款方式未設定的時候改i的顏色+i的事件
//        UIImageView *accessory=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_greenSign.png"]];
//        cell.accessoryView=accessory;
    }else{
        cell.alertSignAccount.hidden=YES;
        //TODO: cell的accessory要變回來
        //cell.accessoryView=
    }
    
    return cell;
}

#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"Add Receipt Segue From Receipts"]) {
        NSLog(@"Setting %@ as a delegate of AddReceiptTVC",self.class);
        AddReceiptTVC *addReceiptTVC=segue.destinationViewController;
        addReceiptTVC.delegate=self;
        addReceiptTVC.managedObjectContext=self.managedObjectContext;
        addReceiptTVC.currentTrip=self.currentDay.inTrip;
        //addReceiptTVC.selectedDayString=[self.dateFormatter stringFromDate:self.currentDay.date];
    }else if ([segue.identifier isEqualToString:@"Add Receipt Segue From Receipts Button"]) {
        NSLog(@"Setting %@ as a delegate of AddReceiptTVC",self.class);
        AddReceiptTVC *addReceiptTVC=segue.destinationViewController;
        addReceiptTVC.delegate=self;
        addReceiptTVC.managedObjectContext=self.managedObjectContext;
        addReceiptTVC.currentTrip=self.currentDay.inTrip;
        addReceiptTVC.selectedDayString=[self.dateFormatter stringFromDate:self.currentDay.date];
        //addReceiptTVC.selectedDayString=[self.dateFormatter stringFromDate:self.currentDay.date];
    }else if ([segue.identifier isEqualToString:@"Receipt Detail Segue"]){
        NSLog(@"Setting ReceiptsCDTVC as a delegate of ReceiptDetailTVC");
        ReceiptDetailTVC * receiptDetailTVC=segue.destinationViewController;
        receiptDetailTVC.delegate=self;
        receiptDetailTVC.managedObjectContext=self.managedObjectContext;
//        NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
        
        NSIndexPath *indexPath=(NSIndexPath *)sender;   //因為在accessoryButtonTappedForRowWithIndexPath事件裡傳indexPath過來
        self.selectedReceipt=[self.fetchedResultsController objectAtIndexPath:indexPath];
        receiptDetailTVC.receipt=self.selectedReceipt;
    }else if([segue.identifier isEqualToString:@"Items List Segue From Receipts"]){
        NSLog(@"Setting ReceiptsCDTVC as a delegate of ItemsCDTVC");
        ItemsCDTVC *itemsCDTVC=segue.destinationViewController;
//        NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
        
        NSIndexPath *indexPath=(NSIndexPath *)sender;   //因為在accessoryButtonTappedForRowWithIndexPath事件裡傳indexPath過來
        self.selectedReceipt=[self.fetchedResultsController objectAtIndexPath:indexPath];
        itemsCDTVC.currentReceipt=self.selectedReceipt;
        itemsCDTVC.managedObjectContext=self.managedObjectContext;

        
    }
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Receipt *receiptDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@(%@)", receiptDelete.desc,receiptDelete.total);
        //要刪Receipt之前先把該Receipt裏的所有item刪掉
        for (Item *itemDelete in receiptDelete.items) {
            [self.managedObjectContext deleteObject:itemDelete];
        }
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
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Items List Segue From Receipts" sender:indexPath];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Receipt Detail Segue" sender:indexPath];
}
#pragma mark - delegation
-(void)theSaveButtonOnTheAddReceiptWasTapped:(AddReceiptTVC *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
