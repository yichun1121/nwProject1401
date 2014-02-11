//
//  AddDayTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@class AddDayTVC;
@protocol AddDayTVCDelegate <NSObject>
-(void)theSaveButtonOnTheAddDayWasTapped:(AddDayTVC *)controller;
@end

@interface AddDayTVC : UITableViewController<UITextFieldDelegate>
@property NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)id<AddDayTVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *dayName;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dayResultString;
//@property (weak,nonatomic)IBOutlet UITextField *dayDescription;

@property Trip *currentTrip;
@end
