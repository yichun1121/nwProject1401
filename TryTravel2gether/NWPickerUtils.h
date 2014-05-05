//
//  NWPickerUtils.h
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWPickerUtils : NSObject


/*!
 設定長出Picker的起點高度，於選取TableView中的cellRect下方。
 並在tableView contentSize加入Picker的高度
 */
+(void)setPickerInTableView:(UIDatePicker *)picker tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


/*!
 清除UIScrollView下的所有的picker
 */
+(void)dismissPicker:(UIScrollView *)tagView;
@end
