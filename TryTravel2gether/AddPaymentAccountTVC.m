//
//  AddPaymentAccountTVC.m
//  TryTravel2gether
//
//  Created by apple on 2015/1/16.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "AddPaymentAccountTVC.h"

@interface AddPaymentAccountTVC ()

@end

@implementation AddPaymentAccountTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize selectedPayWay=_selectedPayWay;
@synthesize selectedGuyInTrip=_selectedGuyInTrip;
@synthesize currentTrip=_currentTrip;

- (void)viewDidLoad {
    [super viewDidLoad];
    //顯示賬戶資訊
}

-(void) save:(id)sender{
    
    NSLog(@"Telling the AddPaymentAccountTVC Delegate that Save was tapped on the AddPaymentAccountTVC");
    
    Account *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                               inManagedObjectContext:self.managedObjectContext];
    
    account.name = self.selectedGuyInTrip.guy.name;
    account.payWay=self.selectedPayWay;

    [self.managedObjectContext save:nil];  // write to database
 
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
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
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)payWayWasSelectedInPayWayCDTVC:(PayWayCDTVC *)controller{
    self.selectedPayWay=controller.selectedPayWay;
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
