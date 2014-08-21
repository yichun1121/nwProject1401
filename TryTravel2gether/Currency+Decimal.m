//
//  Currency+Decimal.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/8/21.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Currency+Decimal.h"

@implementation Currency (Decimal)
-(int)decimalDigit{
    NSArray *arrDigit0=[[NSArray alloc]initWithObjects:@"TWD",@"JPY",@"THB",@"PHP",@"IDR",@"KRW",@"VND", nil];
    NSArray *arrDigit1=[[NSArray alloc]initWithObjects:@"HKD",@"ZAR",@"SEK",@"MYR",@"CNY", nil];
    NSArray *arrDigit2=[[NSArray alloc]initWithObjects:@"USD",@"GBP",@"AUD",@"CAD",@"SGD",@"CDF",@"NZD",@"ERU", nil];
    int digit=2;
    if ([arrDigit0 containsObject:self.standardSign]) {
        digit=0;
    }else if ([arrDigit1 containsObject:self.standardSign]) {
        digit= 1;
    }else if ([arrDigit2 containsObject:self.standardSign]) {
        digit= 2;
    }
    return digit;
}
-(NSNumberFormatter *)numberFormatter{
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfEven];
//    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    formatter.maximumFractionDigits=self.decimalDigit;
    return formatter;
}
@end
