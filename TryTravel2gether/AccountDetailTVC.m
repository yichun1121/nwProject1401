//
//  AccountDetailTVC.m
//  TryTravel2gether
//
//  Created by apple on 2015/1/27.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "AccountDetailTVC.h"
#import "Account.h"



@interface AccountDetailTVC ()

@end

@implementation AccountDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedGuyInTrip=[self.selectedAccount.guysInTrip anyObject];
    self.selectedPayWay=self.selectedAccount.payWay;
    self.accountName.text=self.selectedAccount.name;
    self.ownerCell.detailTextLabel.text=self.selectedGuyInTrip.guy.name;
    self.payWayCell.detailTextLabel.text=self.selectedPayWay.name;
}

-(void) save:(id)sender{
    
    NSLog(@"Telling the AccountDetailTVC Delegate that Save was tapped on the AccountDetailTVC");
    
    [self.selectedAccount setName:self.accountName.text];
    self.selectedAccount.payWay=self.selectedPayWay;
    [self.selectedAccount removeGuysInTripObject:[self.selectedAccount.guysInTrip anyObject]];
    [self.selectedAccount addGuysInTripObject:self.selectedGuyInTrip];
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAccountDetailTVCWasTapped:self];
}

#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"Select Account Owner Segue From AccountDetailTVC"]){
        NSLog(@"Setting AccountDetailTVC as a delegate of SelectAccountOwnerCDTVC");
        SelectAccountOwnerCDTVC *selectAccountOwnerCDTVC=segue.destinationViewController;
        selectAccountOwnerCDTVC.delegate=self;
        selectAccountOwnerCDTVC.managedObjectContext=self.managedObjectContext;
        selectAccountOwnerCDTVC.currentTrip=self.selectedGuyInTrip.inTrip;
        selectAccountOwnerCDTVC.selectedGuyInTrip=self.selectedGuyInTrip;
    }else if([segue.identifier isEqualToString:@"PayWay Segue From AccountDetailTVC"]){
        NSLog(@"Setting AccountDetailTVC as a delegate of PayWayCDTVC");
        PayWayCDTVC *payWayCDTVC=segue.destinationViewController;
        payWayCDTVC.delegate=self;
        payWayCDTVC.managedObjectContext=self.managedObjectContext;
        payWayCDTVC.selectedPayWay=self.selectedPayWay;
        
    }
}

@end
