//
//  PayWayCDTVC.m
//  TryTravel2gether
//
//  Created by apple on 2015/1/17.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "PayWayCDTVC.h"

@interface PayWayCDTVC ()

@end

@implementation PayWayCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;

#pragma mark - FetchedResultsController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

-(void)setupFetchedResultController{
    
    NSString *entityName=@"PayWay";
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
    PayWay *payWay=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=payWay.name;
    if ([payWay.name isEqualToString: self.selectedPayWay.name]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    self.selectedGroup=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedPayWay=[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate payWayWasSelectedInPayWayCDTVC:self];
}



@end
