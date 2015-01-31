//
//  TripAccountCDTVC.m
//  TryTravel2gether
//
//  Created by apple on 2015/1/24.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "TripAccountCDTVC.h"

@interface TripAccountCDTVC ()

@end

@implementation TripAccountCDTVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Table view data source
/*!組合TableViewCell的顯示內容
 */
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    
    Account *account=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",account.name];
    return cell;
}
#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - ➤ Navigation：Segue Settings
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"Add Payment Account Segue From TripAccountCDTVC"]) {
        AddPaymentAccountTVC *addPaymentAccountTVC=segue.destinationViewController;
        addPaymentAccountTVC.currentTrip=self.currentTrip;
        addPaymentAccountTVC.delegate=self;
        addPaymentAccountTVC.managedObjectContext=self.managedObjectContext;
    }else if ([segue.identifier isEqualToString:@"Account Detail Segue From TripAccountCDTVC"]){
        self.selectedAccount=[self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        AccountDetailTVC *accountDetailTVC=segue.destinationViewController;
        accountDetailTVC.selectedAccount=self.selectedAccount;
        accountDetailTVC.delegate=self;
        accountDetailTVC.managedObjectContext=self.managedObjectContext;
    }
}
#pragma mark - delegation

- (void)theSaveButtonOnTheAccountDetailTVCWasTapped:(AccountDetailTVC *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
