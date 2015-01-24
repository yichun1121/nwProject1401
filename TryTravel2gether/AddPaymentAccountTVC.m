//
//  AddPaymentAccountTVC.m
//  TryTravel2gether
//
//  Created by apple on 2015/1/16.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "AddPaymentAccountTVC.h"


@interface AddPaymentAccountTVC ()
@property (strong, nonatomic) IBOutlet UITextField *accountName;

@end

@implementation AddPaymentAccountTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize selectedPayWay=_selectedPayWay;
@synthesize selectedGuyInTrip=_selectedGuyInTrip;
@synthesize currentTrip=_currentTrip;
@synthesize accountName=_accountName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accountName.delegate=self;
    //顯示賬戶資訊
    self.ownerCell.textLabel.text=@"Owner";
    self.ownerCell.detailTextLabel.text=@"Undefined";
    self.payWayCell.textLabel.text=@"PayWay";
    self.payWayCell.detailTextLabel.text=@"Undefined";
}

-(void) save:(id)sender{
    
    NSLog(@"Telling the AddPaymentAccountTVC Delegate that Save was tapped on the AddPaymentAccountTVC");
    
    Account *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                               inManagedObjectContext:self.managedObjectContext];
    
    account.name = self.accountName.text;
    account.payWay=self.selectedPayWay;
    [account addGuysInTripObject:self.selectedGuyInTrip];
    
    
    [self.managedObjectContext save:nil];  // write to database
   
 
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddPaymentAccountTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddPaymentAccountTVCWasTapped:self];
}
#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if([segue.identifier isEqualToString:@"Select Account Owner Segue From Add Payment Account"]){
        NSLog(@"Setting AddPaymentAccountTVC as a delegate of SelectAccountOwnerCDTVC");
        SelectAccountOwnerCDTVC *selectAccountOwnerCDTVC=segue.destinationViewController;
        selectAccountOwnerCDTVC.delegate=self;
        selectAccountOwnerCDTVC.managedObjectContext=self.managedObjectContext;
        selectAccountOwnerCDTVC.currentTrip=self.currentTrip;
        selectAccountOwnerCDTVC.selectedGuyInTrip=self.selectedGuyInTrip;
    }else if([segue.identifier isEqualToString:@"PayWay Segue From Add Payment Account"]){
        NSLog(@"Setting AddPaymentAccountTVC as a delegate of PayWayCDTVC");
        PayWayCDTVC *payWayCDTVC=segue.destinationViewController;
        payWayCDTVC.delegate=self;
        payWayCDTVC.managedObjectContext=self.managedObjectContext;
        payWayCDTVC.selectedPayWay=self.selectedPayWay;
        
    }
}
#pragma mark - delegation
-(void)guyWasSelectedInSelectAccountOwnerCDTVC:(SelectAccountOwnerCDTVC *)controller{
    self.selectedGuyInTrip=controller.selectedGuyInTrip;
    self.ownerCell.detailTextLabel.text=self.selectedGuyInTrip.guy.name;
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)payWayWasSelectedInPayWayCDTVC:(PayWayCDTVC *)controller{
    self.selectedPayWay=controller.selectedPayWay;
    self.payWayCell.detailTextLabel.text=self.selectedPayWay.name;
    [controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
