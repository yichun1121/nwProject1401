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


@implementation Day (Expend)

-(NSNumber *)dayExpendUsingMainCurrency{
    Currency *mainCurrency=self.inTrip.mainCurrency;
    NSLog(@"Find Main Currency...%@",mainCurrency);
    return [self dayExpendUsing:mainCurrency];
}
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
@end
