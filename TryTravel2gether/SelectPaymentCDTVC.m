//
//  SelectPaymentCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectPaymentCDTVC.h"
#import "PayWay.h"

@interface SelectPaymentCDTVC()

@end

@implementation SelectPaymentCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;


#pragma mark - FetchedResultsController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Account";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY guysInTrip.inTrip=%@",self.currentTrip];
    request.sortDescriptors=[NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    
    
    [self performFetch];
    
}



#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
   
    Account *account=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",account.name];
    if ([account.name isEqualToString: self.selectedAccount.name]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedAccount=[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate theSaveButtonOnTheSelectPaymentWasTapped:self];
}
#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSLog(@"Setting SelectPaymentCDTVC as a delegate of AddPaymentAccountTVC...");

    if ([segue.identifier isEqualToString:@"Add Payment Account Segue From PaymentCDTVC"]) {
        AddPaymentAccountTVC *addPaymentAccountTVC=segue.destinationViewController;
        addPaymentAccountTVC.currentTrip=self.currentTrip;
        addPaymentAccountTVC.delegate=self;
        addPaymentAccountTVC.managedObjectContext=self.managedObjectContext;
    }
}
#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Account *accountDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@", accountDelete.name);
        [self.managedObjectContext deleteObject:accountDelete];
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

- (void)theSaveButtonOnTheAddPaymentAccountTVCWasTapped:(AddPaymentAccountTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}


@end
