//
//  SelectPaymentCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Account.h"
@class SelectPaymentCDTVC;
@protocol SelectPaymentCDTVCDelegate<NSObject>
-(void)theSaveButtonOnTheSelectPaymentWasTapped:(SelectPaymentCDTVC *)controller;
@end
@interface SelectPaymentCDTVC : CoreDataTableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) id<SelectPaymentCDTVCDelegate> delegate;
@property (strong,nonatomic)Account* selectedAccount;
@end
