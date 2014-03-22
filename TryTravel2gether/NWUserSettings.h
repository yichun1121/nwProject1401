//
//  NWUserSettings.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/20.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface NWUserSettings : NSObject
@property (strong,nonatomic) NSManagedObjectContext * managedObjectContext;
-(Currency *)getDefaultCurrency;
@end
