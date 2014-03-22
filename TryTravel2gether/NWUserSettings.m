//
//  NWUserSettings.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/20.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWUserSettings.h"

@implementation NWUserSettings
@synthesize managedObjectContext=_managedObjectContext;
-(Currency *)getDefaultCurrency{
    NSString *defaultCurrencyStandardSign=@"USD";
    NSString *defaultCurrencyName=@"U.S.Dollar";
    NSString *defaultCurrencySign=@"＄";
    NSLog(@"Find the default currency standard sign:%@.",defaultCurrencyStandardSign);
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(standardSign = %@)", defaultCurrencyStandardSign];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        return [self newCurrencyWithName:defaultCurrencyName Sign:defaultCurrencySign StandardSign:defaultCurrencyStandardSign];
    } else {
        return objects[0];
    }
}
-(Currency *)newCurrencyWithName:(NSString*)name Sign:(NSString *)sign StandardSign:(NSString *)standardSign{
    NSLog(@"Create new Currency:%@ in NWUserSettings.",standardSign);
    
    Currency *currency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency"
                                                       inManagedObjectContext:self.managedObjectContext];
    currency.name=name;
    currency.sign=sign;
    currency.standardSign=standardSign;
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Create the new currency in Currency entity.");
    return currency;
}
@end
