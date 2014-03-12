//
//  Currency+CRUD.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "Currency+CRUD.h"

@implementation Currency (CRUD)
@dynamic managedObjectContext;
-(Currency *)getWithStandardSign:(NSString *)standardSign{
    NSLog(@"Find the standard sign:%@ in currencies.",standardSign);
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(standardSign = %@)", standardSign];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        return [self newCurrencyWithName:@"" Sign:@"" StandardSign:standardSign];
    } else {
        return objects[0];
    }
}
-(Currency *)newCurrencyWithName:(NSString*)name Sign:(NSString *)sign StandardSign:(NSString *)standardSign{
    NSLog(@"Create new Day in Currency+CRUD");
    
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
