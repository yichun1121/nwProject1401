//
//  TripDetailCDTVC.h
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@class TripDetailTVC;
//介面 (interface) 中若需要用到其他類別 (class) 名稱，除了可先用 #import 直接引入標頭檔外，亦可用 @class 指令宣告可用的類別名稱。

/*
 建立一個監聽AddTrip的機制：AddTripTVCDelegate，
 會以protocol方式定義，是因為觸發訊號的程式並不知道實際執行的內容為何，所以只定義method名稱。
 只要想在save按下之後做事的人都要實作這個method： theSaveButtonOnTheAddTripTVCWasTapped。
 */
@protocol TripDetailTVCDelegate
- (void)theSaveButtonOnTheTripDetailTVCWasTapped:(TripDetailTVC *)controller; //上面要加@class AddTripTVC;才可以用
@end


@interface TripDetailTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *tripName; //TODO: tripName不知道要weak還是strong
@property (nonatomic, weak) id <TripDetailTVCDelegate> delegate;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)Trip *trip;    //在.h設一個Trip property可以讓List傳一個Trip進來，然後顯示及修改

@property (weak, nonatomic) IBOutlet UITableViewCell *startDate;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDate;

@property (strong,nonatomic) NSIndexPath *actingDateCellIndexPath;
@property (strong,nonatomic) NSIndexPath *actingPickerCellIndexPath;

- (IBAction)save:(id)sender;

@end
