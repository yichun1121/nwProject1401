//
//  AddReceiptTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"
#import "Day.h"
#import "TripDaysTVC.h"
#import "CurrencyCDTVC.h"


@class AddReceiptTVC;

@protocol AddReceiptTVCDelegate <NSObject>

-(void)theSaveButtonOnTheAddReceiptWasTapped:(AddReceiptTVC *)controller;

@end

@interface AddReceiptTVC : UITableViewController<UITextFieldDelegate,TripDaysTVCDelegate,CurrencyCDTVCDelegate>

@property (weak,nonatomic)id <AddReceiptTVCDelegate> delegate;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *totalPrice;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;

//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong,nonatomic) NSString *selectedDayString;
@property (strong,nonatomic) Trip *currentTrip;


-(IBAction)save:(id)sender;

#pragma mark - 新增加的內容for picker action
@property (strong,nonatomic) NSIndexPath *actingDateCellIndexPath;      //一定要設strong
@end
