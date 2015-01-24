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
@property (strong,nonatomic)NSArray *fetchedObjects;
@end

@implementation SelectPaymentCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize fetchedObjects=_fetchedObjects;

#pragma mark - FetchedResultsController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Account";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY guysInTrip.inTrip.name=%@",@"HK"];
    request.sortDescriptors=[NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    
    
    [self performFetch];
    
}

-(NSArray *)fetchedObjects{
    if(!_fetchedObjects){
        _fetchedObjects = [self.fetchedResultsController fetchedObjects];
    }
    return _fetchedObjects;
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
    Account *account=[self.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@'s %@",account.name,account.payWay.name];
    NSString *selfAccountPayWayName=[NSString stringWithFormat:@"%@'s %@",self.selectedAccount.name,self.selectedAccount.payWay.name];
    if ([cell.textLabel.text isEqualToString: selfAccountPayWayName]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    self.selectedGroup=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedAccount=self.fetchedObjects[indexPath.row];
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
#pragma mark - delegation

- (void)theSaveButtonOnTheAddPaymentAccountTVCWasTapped:(AddPaymentAccountTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}


@end
