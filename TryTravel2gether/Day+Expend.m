//
//  Day+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Day+Expend.h"
#import "Trip.h"
#import "DayCurrency.h"
#import "Receipt.h"
#import "Currency.h"
#import "Receipt+Calculate.h"


@implementation Day (Expend)
/*!計算本日指定貨幣的收據花費總額
 currency：貨幣
 */
-(NSNumber *)dayExpendUsingMainCurrency{
    Currency *mainCurrency=self.inTrip.mainCurrency;
    NSLog(@"Find Main Currency...%@",mainCurrency);
    return [self dayExpendUsing:mainCurrency];
}
/*!計算本日主要貨幣的收據花費總額*/
-(NSNumber *)dayExpendUsing:(Currency *)currency{
    
    //-----Date Formatter----------
    NSDateFormatter *dateFormatter;
    dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    NSString *dateString=[dateFormatter stringFromDate:self.date];
    NSLog(@"Calculating date:%@ Currency Spending...",dateString);
    
    double mainSpending=0;
    for (DayCurrency * dayCurrency in self.dayCurrencies) {
        if (dayCurrency.currency==currency) {
            for (Receipt * receipt in dayCurrency.receipts) {
                double receiptSpending=[receipt.total doubleValue];
                mainSpending+=receiptSpending;
            }
            break;
        }
    }
    NSLog(@"Currency Spending:%@ %g",currency.sign,mainSpending);
    return [NSNumber numberWithDouble:mainSpending];

}
/*!檢查本日內所有收據的金額是否已全部設定（YES:已設定完成, NO:尚未設定完成）
 */
-(BOOL)isReceiptAllSet{
    BOOL isAllSet=YES;
    for (Receipt *receipt in self.receipts) {
        if (!receipt.isItemsAllSet) {
            isAllSet=NO;
            break;
        }
    }
    return isAllSet;
}
/*!本日中所有receipt的歸屬者是否已經設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isReceiptGroupAllSet{
    BOOL isAllSet=YES;
    for (Receipt *receipt in self.receipts) {
        if (!receipt.isItemsGroupAllSet) {
            isAllSet=NO;
            break;
        }
    }
    return isAllSet;
}

/*!本日中所有receipt的帳戶是否已經設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isReceiptAccountAllSet{
    BOOL isAllSet=YES;
    for (Receipt *receipt in self.receipts) {
        if (!receipt.account) {
            isAllSet=NO;
            break;
        }
    }
    return isAllSet;
}
@end
