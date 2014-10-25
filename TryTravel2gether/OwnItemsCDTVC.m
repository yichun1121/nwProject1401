//
//  OwnItemsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/23.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "OwnItemsCDTVC.h"
#import "Item.h"
#import "Receipt.h"
#import "DayCurrency.h"
#import "Currency.h"
#import "Currency+Decimal.h"
#import "Day.h"
#import "CatInTrip.h"
#import "Itemcategory.h"
#import "Itemcategory+Colorful.h"
#import "Group.h"
#import "NWCustCellOwnItem.h"
#import "ItemDetailTVC.h"


@interface OwnItemsCDTVC()
@property NSDateFormatter *dateFormatter;
@end
@implementation OwnItemsCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize dateFormatter=_dateFormatter;
-(void)viewDidLoad{
    [super viewDidLoad];
    NSString *userName=@"Personal List";
    for (Group *group in self.userGroups) {
        if ([group.guysInTrip count]==1) {
            userName=group.name;
            break;
        }
    }
    self.navigationItem.title=userName;
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    [self.dateFormatter setDateFormat:@"M/d"];
    
    //-----註冊CustomCell----------
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellOwnItem" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Item";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
//    request.predicate=[NSPredicate predicateWithFormat:@"ANY group==%@",self.userGroups];
    request.predicate=[NSPredicate predicateWithFormat:@"group in %@",self.userGroups];
    
    request.sortDescriptors=[NSArray arrayWithObjects:
                             [NSSortDescriptor sortDescriptorWithKey:@"receipt.day.date" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
                             [NSSortDescriptor sortDescriptorWithKey:@"receipt.time" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
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
    
    NWCustCellOwnItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellOwnItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(NWCustCellOwnItem *)configureCell:(NWCustCellOwnItem *)cell AtIndexPath:(NSIndexPath *)indexPath{
    Item *item=[self.fetchedResultsController objectAtIndexPath:indexPath];
    //-----購買日期-----
    [cell.lblDate setText:[self.dateFormatter stringFromDate:item.receipt.day.date]];
    
    //-----分類圖示-----
    [cell.imgCategory setImage:item.catInTrip.category.image];
    [cell.imgCategory setBackgroundColor:item.catInTrip.category.color];
    [cell.imgCategory.layer setBorderColor:[item.catInTrip.category.color CGColor]];
    [cell.imgCategory.layer setBorderWidth:0];
    [cell.imgCategory.layer setMasksToBounds:YES];
    [cell.imgCategory.layer setCornerRadius:4.0];

    //-----購買項目-----
    [cell.lblName setText:item.name];
    
    //-----幣別顯示-----
    Currency * currency=item.receipt.dayCurrency.currency;
    [cell.lblCurrency setText:currency.standardSign];
    
    //-----金額顯示-----
    double totalPrice=[item.price doubleValue] *[item.quantity doubleValue];
    totalPrice=totalPrice/[item.group.guysInTrip count];
    NSString *totalPriceString=[currency.numberFormatter stringFromNumber:[NSNumber numberWithDouble: totalPrice]];
    [cell.lblTotal setText:[NSString stringWithFormat:@"%@", totalPriceString]];
    
    //-----群組圖示-----
    if ([item.group.guysInTrip count]>1) {
        cell.imgGroup.image=[UIImage imageNamed:@"group"];
    }else {
        cell.imgGroup.image=nil;
    }
    
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Item Segue From OwnItems" sender:indexPath];
}
#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Item Segue From OwnItems"]) {
        NSLog(@"Setting %@ as a delegate of ItemDetailTVC",self.class);
        Item * selectedItem=[self.fetchedResultsController objectAtIndexPath:sender];
        ItemDetailTVC * itemDetailTVC=[segue destinationViewController];
        itemDetailTVC.managedObjectContext=self.managedObjectContext;
        itemDetailTVC.currentReceipt=selectedItem.receipt;
        itemDetailTVC.currentItem=selectedItem;
        itemDetailTVC.delegate=self;
    }
    
}

#pragma mark - Delegation
-(void)theSaveButtonOnTheAddItemWasTapped:(AddItemTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}
@end
