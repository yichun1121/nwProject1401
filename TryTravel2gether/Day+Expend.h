//
//  Day+Expend.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Day.h"
#import "DayCurrency.h"

@interface Day (Expend)
/*!計算本日指定貨幣的收據花費總額
 currency：貨幣
 */
-(NSNumber *)dayExpendUsing:(Currency *)currency;
/*!計算本日主要貨幣的收據花費總額*/
-(NSNumber *)dayExpendUsingMainCurrency;

/*!檢查本日內所有收據的金額是否已全部設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isReceiptAllSet;
/*!本日中所有receipt的歸屬者是否已經設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isReceiptGroupAllSet;
@end
