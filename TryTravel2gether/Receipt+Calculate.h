//
//  Receipt+Calculate.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/30.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Receipt.h"

@interface Receipt (Calculate)

/*!計算本Receipt中已設定價格的物品總和
 */
-(NSNumber *)calculateSumOfAllItems;
/*!回傳尚未設定物品之金額
 */
-(NSNumber *)getMoneyRemaining;
/*!Receipt中的金額是否已全部設定（YES:已設定完成, NO:尚未設定完成）
 */
-(BOOL)isItemsAllSet;
/*!取得新增下一筆item時該設定的流水號
 */
-(NSNumber *)getNextItemSerialNumberInReceipt;
/*!Receipt中所有item的歸屬者是否已經設定（YES:已設定完成, NO:尚未設定完成）*/
-(BOOL)isItemsGroupAllSet;
@end
