//
//  ReceiptDetailTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripDaysTVC.h"
#import "CurrencyCDTVC.h"
#import "Receipt.h"
#import "Calculator.h"

@class ReceiptDetailTVC;
@protocol ReceiptDetailTVCDelegate <NSObject>

-(void)theSaveButtonOnTheAddReceiptWasTapped:(ReceiptDetailTVC *)controller;

@end

@interface ReceiptDetailTVC : UITableViewController<UITextFieldDelegate,TripDaysTVCDelegate,CurrencyCDTVCDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CalculatorDelegate>

@property (weak,nonatomic)id <ReceiptDetailTVCDelegate> delegate;
@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;


@property (strong,nonatomic) NSString *selectedDayString;
@property (strong,nonatomic) Receipt *receipt;

//計算機算出來的結果
@property(strong, nonatomic) NSNumber *result;
@property(strong, nonatomic) NSMutableArray * arrayOfStack;


-(IBAction)save:(id)sender;
@end

