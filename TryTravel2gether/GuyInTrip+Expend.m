//
//  GuyInTrip+Expend.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "GuyInTrip+Expend.h"
#import "Trip.h"
#import "Group.h"
#import "Item.h"
#import "Receipt.h"
#import "DayCurrency.h"
#import "Item+Expend.h"
#import "Guy.h"
@implementation GuyInTrip (Expend)
-(NSNumber * )totalExpendUsingCurrency:(Currency *)currency{
    double total=0;
    //TODO:未完成的全程花費邏輯
    
    NSString *savingString=@"";
    savingString=[savingString stringByAppendingString:[NSString stringWithFormat:@"Name: %@ Currency: %@",self.guy.name,currency.standardSign]];
    for (Group *inGroup in self.groups) {
        for (Item * item in inGroup.items) {
            if (item.receipt.dayCurrency.currency==currency) {
                total+=[item.sharedPrice doubleValue];
                savingString=[savingString stringByAppendingString:[NSString stringWithFormat:@"\n%@\t%@",item.sharedPrice,item.name]];
                //ToDo:Log記錄
                savingString=[savingString stringByAppendingString:[NSString stringWithFormat:@"\t(%@*%@/%lu)",item.price,item.quantity,(unsigned long)[item.group.guysInTrip count]]];
            }
        }
    }
    savingString=[NSString stringWithFormat:@"幣別總計：%g\n%@",total,savingString];
    NSString *fileName=[NSString stringWithFormat:@"Trip%@%@_%@.tsv",self.inTrip.tripIndex,self.guy.name,currency.standardSign ];
    [self saveDataIntoFile:savingString withName:fileName];
    return [NSNumber numberWithDouble:total];
}
-(NSString *)totalExpendWithMainCurrencySign{
    Currency *currency=self.inTrip.mainCurrency;
    return [NSString stringWithFormat:@"%@ %@",currency.sign,[self totalExpendUsingCurrency:currency]];
}
-(void)saveDataIntoFile:(NSString *)savingString withName:(NSString *)fileName{
    //Saving file
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSURL* url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
    
    NSString *path = [url.path stringByAppendingPathComponent:fileName];
    
//    NSString *destination = [url stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    
    BOOL succeeded = [savingString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (succeeded) {
        NSLog(@"Success at: %@",path);
    } else {
        NSLog(@"Failed to store. Error: %@",error);
    }
}
@end
