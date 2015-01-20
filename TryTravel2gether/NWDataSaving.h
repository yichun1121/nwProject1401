//
//  NWDataSaving.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWDataSaving : NSObject
+(void)saveDataIntoFile:(NSString *)savingString withName:(NSString *)fileName;
@end
