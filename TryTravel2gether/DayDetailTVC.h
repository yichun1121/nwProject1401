//
//  DayDetailTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/2/11.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
@class DayDetailTVC;
@protocol DayDetailTVCDelegate <NSObject>

-(void)theSaveButtonOnTheDayDetailTVCWasTapped:(DayDetailTVC *)controller;

@end

@interface DayDetailTVC : UITableViewController<UITextFieldDelegate>

@property (nonatomic, weak) id <DayDetailTVCDelegate> delegate;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableViewCell *tripInfoCell;
@property (weak, nonatomic) IBOutlet UITextField *dayName;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dayResultString;
@property(strong,nonatomic) Day *day;
@end
