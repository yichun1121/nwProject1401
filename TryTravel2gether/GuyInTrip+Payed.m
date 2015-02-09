//
//  GuyInTrip+Payed.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "GuyInTrip+Payed.h"
#import "Trip.h"
#import "Currency.h"
#import "Guy.h"
#import "Account.h"
#import "Receipt.h"
#import "DayCurrency.h"
#import "NWDataSaving.h"

@implementation GuyInTrip (Payed)

-(NSNumber *)totalPayedUsingCurrency:(Currency *)currency{
    double total=0;
    NSString *savingString=@"";
    savingString=[savingString stringByAppendingString:[NSString stringWithFormat:@"Name: %@ Currency: %@",self.guy.name,currency.standardSign]];
    for (Account * account in self.accounts) {
        for (Receipt * receipt in account.receipts) {
            if (receipt.dayCurrency.currency==currency) {
                total+=[receipt.total doubleValue];
                savingString=[savingString stringByAppendingString:[NSString stringWithFormat:@"\n%@\t%@",receipt.total,receipt.desc]];
            }
        }
    }
    savingString=[NSString stringWithFormat:@"幣別總計：%g\n%@",total,savingString];
    NSString *fileName=[NSString stringWithFormat:@"Trip%@%@_%@_Payed.tsv",self.inTrip.tripIndex,self.guy.name,currency.standardSign ];
    NWDataSaving *dataSaving=[NWDataSaving new];
    [dataSaving saveDataIntoFile:savingString withFileName:fileName];
    return [NSNumber numberWithDouble:total];

}
-(NSString *)totalPayedWithMainCurrencySign{
    Currency *currency=self.inTrip.mainCurrency;
    return [NSString stringWithFormat:@"%@ %@",currency.sign,[self totalPayedUsingCurrency:currency]];
}
@end
