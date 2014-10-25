//
//  Receipt+Calculate.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/30.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt+Calculate.h"
#import "Item.h"
#import "Item+Expend.h"

@implementation Receipt (Calculate)
/*!計算本Receipt中已設定價格的物品總和
 */
-(NSNumber *)calculateSumOfAllItems{
    double sum=0;
    for (Item *item in self.items) {
        sum+=[item.totalPrice doubleValue];
    }
    return [NSNumber numberWithDouble:sum];
}
/*!回傳尚未設定物品之金額
 */
-(NSNumber *)getMoneyRemaining{
    double remaining=[self.total doubleValue]-[[self calculateSumOfAllItems]doubleValue];
    return [NSNumber numberWithDouble:remaining];
}
/*!Receipt中的金額是否已全部設定（YES:已設定完成, NO:尚未設定完成）
 */
-(BOOL)isItemsAllSet{
    BOOL allSet=NO;
    if ([[self getMoneyRemaining]isEqualToNumber:[NSNumber numberWithDouble: 0]]) {
        allSet=YES;
    }
    return allSet;
}
/*!Receipt中所有item的歸屬者是否已經設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isItemsGroupAllSet{
    BOOL allSet=YES;
    for (Item *item in self.items) {
        if (!item.group) {
            allSet=NO;
            break;
        }
    }
    return allSet;
}
/*!取得新增下一筆item時該設定的流水號
 */
-(NSNumber *)getNextItemSerialNumberInReceipt{
    NSLog(@"getting the last item in Receipt:%@ ... @%@",self.desc,self.class);

    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"itemIndex" ascending:NO]];
    NSArray *sortedItems = [[self.items allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    int currentSerialNum=0;
//    for (Item *item in self.items) {
//        if ([item.itemIndex intValue]>serialNum) {
//            serialNum=[item.itemIndex intValue];
//        }
//    }
    if ([self.items count]!=0) {
        Item *item=sortedItems[0];
        currentSerialNum=[item.itemIndex intValue];
    }
    return [NSNumber numberWithInt: currentSerialNum+1];
}
@end
