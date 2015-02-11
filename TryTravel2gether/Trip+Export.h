//
//  Trip+Export.h
//  TryTravel2gether
//
//  Created by YICHUN on 2015/2/9.
//  Copyright (c) 2015年 NW. All rights reserved.
//

#import "Trip.h"

@interface Trip (Export)
typedef enum {
    ExportFileCSV,
    ExportFileTSV,
}ExportFileType;

-(BOOL)exportTripByType:(ExportFileType)type;
-(NSString *)getItemExportRelativeFileNameByType:(ExportFileType)type;
-(NSString *)getReceiptExportRelativeFileNameByType:(ExportFileType)type;
-(NSString *)subfileNameByFileType:(ExportFileType)type;
@end
