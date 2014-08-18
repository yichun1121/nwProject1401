//
//  SelectPaymentCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectPaymentCDTVC.h"

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
    cell.textLabel.text=account.name;
    if ([account.name isEqualToString: self.selectedAccount.name]) {
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


@end
