//
//  AddPaymentAccountTVC.h
//  TryTravel2gether
//
//  Created by apple on 2015/1/16.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAccountOwnerCDTVC.h"
#import "PayWayCDTVC.h"
#import "Account.h"


@class AddPaymentAccountTVC;
@protocol AddPaymentAccountTVCDelegate
- (void)theSaveButtonOnTheAddPaymentAccountTVCWasTapped:(AddPaymentAccountTVC *)controller;
@end



@interface AddPaymentAccountTVC : UITableViewController<UITextFieldDelegate,SelectAccountOwnerCDTVCDelegate,PayWayCDTVCDelegate,NSFetchedResultsControllerDelegate>
@property NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)id<AddPaymentAccountTVCDelegate> delegate;
@property (strong,nonatomic)Trip *currentTrip;
@property (strong,nonatomic)GuyInTrip *selectedGuyInTrip;
@property (strong,nonatomic)PayWay* selectedPayWay;
@property (strong, nonatomic) IBOutlet UITableViewCell *ownerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *payWayCell;


- (IBAction)save:(id)sender;
@end
