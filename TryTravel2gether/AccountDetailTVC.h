//
//  AccountDetailTVC.h
//  TryTravel2gether
//
//  Created by apple on 2015/1/27.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "AddPaymentAccountTVC.h"

@class AccountDetailTVC;
@protocol AccountDetailTVCDelegate

- (void)theSaveButtonOnTheAccountDetailTVCWasTapped:(AccountDetailTVC *)controller;

@end

@interface AccountDetailTVC : AddPaymentAccountTVC

@property (strong,nonatomic)Account *selectedAccount;

@end
