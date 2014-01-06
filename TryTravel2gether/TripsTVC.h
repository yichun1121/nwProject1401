//
//  TripsTVC.h
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTripTVC.h" // so this class can be a AddRoleTVCDelegate

@interface TripsTVC : UITableViewController <AddTripTVCDelegate>
/*  
    TripsTVC繼承UITableViewController（父類別只能有一個）
    後面的括號表示同時俱有AddTripTVCDelegate的功能（也就是會實作Delegate裡面宣告的method，以便在監聽事件觸發後處理）
 */

@end
