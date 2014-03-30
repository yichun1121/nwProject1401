//
//  Receipt+Calculate.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/30.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt+Calculate.h"
#import "Item.h"

@implementation Receipt (Calculate)
/*!計算本Receipt中已設定價格的物品總和
 */
-(double)calculateSumOfAllItems{
    double sum=0;
    for (Item *item in self.items) {
        sum+=[item.price doubleValue]*[item.quantity intValue];
    }
    return sum;
}
/*!回傳尚未設定物品之金額
 */
-(double)getMoneyIsNotSet{
    return [self.total doubleValue]-[self calculateSumOfAllItems];
}
/*!Receipt中的金額是否已全部設定（YES:已設定完成, NO:尚未設定完成）
 */
-(BOOL)itemsAllSet{
    BOOL allSet=NO;
    if ([self getMoneyIsNotSet]==0) {
        allSet=YES;
    }
    return allSet;
}
@end
