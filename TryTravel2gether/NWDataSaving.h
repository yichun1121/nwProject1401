//
//  NWDataSaving.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/1/18.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWData.h"

@interface NWDataSaving : NWData
-(void)saveDataIntoFile:(NSString *)savingString withFileName:(NSString *)relativeName;
-(NSString *)checkedAndCreatedRelativeFolderPath:(NSString *)relativeFolder;
@end
