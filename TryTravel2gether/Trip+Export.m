//
//  Trip+Export.m
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/9.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "Trip+Export.h"
#import "Trip.h"
#import "Day.h"
#import "Receipt.h"
#import "Item.h"
#import "CatInTrip.h"
#import "Itemcategory.h"
#import "Currency.h"
#import "DayCurrency.h"
#import "NWDataSaving.h"
#import "Account.h"
#import "PayWay.h"
#import "Group.h"
#import "GuyInTrip.h"
#import "Guy.h"
#import "Trip+Days.h"
#import "Trip+System.h"
#import "Item+Expend.h"

@implementation Trip (Export)
-(NSString *)getItemExportRelativeFileNameByType:(ExportFileType)type{
    return [NSString stringWithFormat:@"Export/Trip%@/Trip%@_items.%@",self.tripIndex,self.name,[self subfileNameByFileType:type] ];
}
-(NSString *)getReceiptExportRelativeFileNameByType:(ExportFileType)type{
    return [NSString stringWithFormat:@"/Export/Trip%@/Trip%@_receipts.%@",self.tripIndex,self.name,[self subfileNameByFileType:type] ];
}

-(NSString *)subfileNameByFileType:(ExportFileType)type{
    NSString * subfileName=@"";
    switch (type) {
        case ExportFileCSV:
            subfileName=@"csv";
            break;
        case ExportFileTSV:
            subfileName=@"tsv";
            break;
            
        default:
            break;
    }
    return subfileName;
}

-(BOOL)exportTripByType:(ExportFileType)type{
    NSString *outputItemFormat=@"";
    NSString *outputReceiptFormat=@"";
    NSString *subFileName=@"";
    BOOL exportSuccess=NO;
    if (type==ExportFileCSV) {
        outputItemFormat=@"\n%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@";
        outputReceiptFormat=@"\n%@,%@,%@,%@,%@,%@,%@,%@";
        subFileName=@"csv";
    }else if (type==ExportFileTSV){
        outputItemFormat=@"\n%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@";
        outputReceiptFormat=@"\n%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@";
        subFileName=@"tsv";
    }
    //export item & receipt------------------------------------
    NSString *itemSavingString=@"";
    itemSavingString=[itemSavingString stringByAppendingString:
                      [NSString stringWithFormat:outputItemFormat,
                       NSLocalizedString(@"Exp_ItemID", "ExportHead"),
                       NSLocalizedString(@"Exp_DateTime", "ExportHead"),
                       NSLocalizedString(@"Exp_Category", "ExportHead"),
                       NSLocalizedString(@"Exp_ReceiptDesc", "ExportHead"),
                       NSLocalizedString(@"Exp_ItemName", "ExportHead"),
                       NSLocalizedString(@"Exp_Currency", "ExportHead"),
                       NSLocalizedString(@"Exp_UnitPrice", "ExportHead"),
                       NSLocalizedString(@"Exp_Quantity", "ExportHead"),
                       NSLocalizedString(@"Exp_OriginTotal", "ExportHead"),
                       NSLocalizedString(@"Exp_Group", "ExportHead"),
                       NSLocalizedString(@"Exp_Parts", "ExportHead"),
                       NSLocalizedString(@"Exp_ToReceiptID", "ExportHead"),
                       NSLocalizedString(@"Exp_BelongsTo", "ExportHead"),
                       NSLocalizedString(@"Exp_SharePrice", "ExportHead")
                       ]
                      ];
    
    
    NSString *receiptSavingString=@"";
    receiptSavingString=[receiptSavingString stringByAppendingString:
                         [NSString stringWithFormat:outputReceiptFormat,
                          NSLocalizedString(@"Exp_ReceiptID", "ExportHead"),
                          NSLocalizedString(@"Exp_DateTime", "ExportHead"),
                          NSLocalizedString(@"Exp_ReceiptDesc", "ExportHead"),
                          NSLocalizedString(@"Exp_Currency", "ExportHead"),
                          NSLocalizedString(@"Exp_Total", "ExportHead"),
                          NSLocalizedString(@"Exp_Account", "ExportHead"),
                          NSLocalizedString(@"Exp_Payway", "ExportHead"),
                          NSLocalizedString(@"Exp_Payer", "ExportHead")
                          ]
                         ];
    
    int itemSerial=0;
    //流水號格式：TxDxx，後加上收據在該天的流水號
    NSString *serTripID=@"T%@";
    serTripID=[NSString stringWithFormat:serTripID,self.tripIndex];
    for (Day * day in self.days) {
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
        [numberFormatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
        [numberFormatter setPaddingCharacter:@"0"];
        [numberFormatter setMinimumIntegerDigits:2];
        NSString *serDayID=[serTripID stringByAppendingString:[@"D" stringByAppendingString: [numberFormatter stringFromNumber: day.dayIndex]]];//旅遊日流水號
        int receiptSerial=0;
        
        for (Receipt * receipt in day.receipts) {
            receiptSerial=receiptSerial+1;
            //收據代號=旅遊日流水號+該日收據流水號
            NSString *receiptSerID=[serDayID stringByAppendingString:[NSString stringWithFormat:@"R%03i",receiptSerial]];
            NSString *thisCurrencySign=receipt.dayCurrency.currency.standardSign;
            NSString *thisReceiptDesc=receipt.desc;
            NSString *thisReceiptDayTime=[NSString stringWithFormat:@"%@ %@",[Trip.dateFormatter_GMT stringFromDate:receipt.day.date] ,[Trip.timeFormatter_GMT stringFromDate:receipt.time]];
            GuyInTrip *payedGuy=[receipt.account.guysInTrip anyObject];
            receiptSavingString=[receiptSavingString stringByAppendingString:
                                 [NSString stringWithFormat:outputReceiptFormat,
                                  receiptSerID,
                                  thisReceiptDayTime,
                                  thisReceiptDesc,
                                  thisCurrencySign,
                                  [NSString stringWithFormat:@"%@",receipt.total],
                                  receipt.account.name,
                                  receipt.account.payWay.name,
                                  payedGuy.guy.name
                                  ]
                                 ];
            
            for (Item *item in receipt.items) {
                itemSerial=itemSerial+1;
                for (GuyInTrip *guyInTrip in item.group.guysInTrip) {
                    itemSavingString=[itemSavingString stringByAppendingString:
                                      [NSString stringWithFormat:outputItemFormat,
                                       [NSString stringWithFormat:@"R%05i",itemSerial],
                                       thisReceiptDayTime,
                                       item.catInTrip.category.name,
                                       thisReceiptDesc,
                                       item.name,
                                       thisCurrencySign,
                                       item.price,
                                       item.quantity,
                                       item.totalPrice,
                                       item.group.name,
                                       [NSString stringWithFormat:@"%lu", (unsigned long)item.group.guysInTrip.count],
                                       receiptSerID,
                                       guyInTrip.guy.name,
                                       item.sharedPrice
                                       ]
                                      ];
                }
            }
        }
    }
    NWDataSaving *dataSaving=[NWDataSaving new];
    NSString *itemFileName=[self getItemExportRelativeFileNameByType:type];
    [dataSaving saveDataIntoFile:itemSavingString withFileName:itemFileName];
    NSString *receiptFileName=[self getReceiptExportRelativeFileNameByType:type];
    [dataSaving saveDataIntoFile:receiptSavingString withFileName:receiptFileName];
    return exportSuccess;
}
@end
