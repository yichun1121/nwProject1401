//
//  PersonalSharedTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/17.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "PersonalSharedTVC.h"
#import "OwnItemsCDTVC.h"
#import "Guy.h"
#import "Trip+Currency.h"
#import "Currency.h"
#import "GuyInTrip+Payed.h"
#import "GuyInTrip+Expend.h"
#import "Currency+Decimal.h"

@interface PersonalSharedTVC ()
@property (strong,nonatomic)  NSOrderedSet *currecies;
@end

@implementation PersonalSharedTVC
@synthesize currecies=_currecies;
//@synthesize fetchedResultsController=_fetchedResultsController;

#pragma mark - lazy instantiation
-(NSOrderedSet *)currecies{
    if(!_currecies){
        _currecies=[self.currentGuy.inTrip getAllCurrencies];
    }
    return _currecies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row=0;
    switch (section) {
        case 0:
            row=1;
            break;
        case 1:
            row=[self.currecies count];
            break;
        case 2:
            row=[self.currecies count];
            break;
        case 3:
            row=1;
            break;
            
        default:
            row=0;
            break;
    }
    return row;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 1:
            sectionName = NSLocalizedString(@"Payed",@"SectionTitle");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Spend",@"SectionTitle");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    cell.textLabel.font=[UIFont systemFontOfSize:cell.textLabel.font.pointSize];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor whiteColor];
    
    if (indexPath.section==0) {
        cell.textLabel.text=self.currentGuy.guy.name;
    }else if (indexPath.section==1){
        if (indexPath.row<self.currecies.count) {
            
            Currency *currency=self.currecies[indexPath.row];
            NSNumber *totalInCurrency=[self.currentGuy totalPayedUsingCurrency:currency];
            NSString *strTotal=[currency.numberFormatter stringFromNumber:totalInCurrency];
            cell.textLabel.text=[NSString stringWithFormat:@"\t%@\t%@",currency.standardSign,strTotal];
        }
    }else if (indexPath.section==2){
        if (indexPath.row<self.currecies.count) {
            
            Currency *currency=self.currecies[indexPath.row];
            NSNumber *totalInCurrency=[self.currentGuy totalExpendUsingCurrency:currency];
            NSString *strTotal=[currency.numberFormatter stringFromNumber:totalInCurrency];
            cell.textLabel.text=[NSString stringWithFormat:@"\t%@\t%@",currency.standardSign,strTotal];
        }
    }else if (indexPath.section==3){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=NSLocalizedString(@"ShowPersonalSharedItems",@"CellTitle");
        cell.textLabel.font= [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.backgroundColor=[UIColor lightGrayColor];
    }
    
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3){
        //因為頁面上沒有拉segue，所以不能用performSegue（自訂cell但頁面有拉的時候才能用）
        [self moveToOwnItemsCDTVC];
    }
}
#pragma mark - ➤ Navigation：Segue Settings
/*手動移到下一頁：ownItemsCDTVC
 */
- (void)moveToOwnItemsCDTVC{
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
    OwnItemsCDTVC *ownItemsCDTVC=[storyboard instantiateViewControllerWithIdentifier:@"OwnItemsCDTVC"];
    ownItemsCDTVC.managedObjectContext=self.managedObjectContext;
    GuyInTrip *guy=self.currentGuy;
    ownItemsCDTVC.userGroups=guy.groups;
    NSMutableArray *viewcontrollers=[self.navigationController.viewControllers mutableCopy];
    [viewcontrollers addObject:ownItemsCDTVC];
//    self.navigationController.viewControllers=[viewcontrollers copy];
//    [self.navigationController popToViewController:ownItemsCDTVC animated:YES];

    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:ownItemsCDTVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@""]){

    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

@end
