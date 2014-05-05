//
//  NWPickerUtils.m
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWPickerUtils.h"
@interface NWPickerUtils()
/*!
 設定長Picker的起點高度，於選到的cellRect下方。
 selectTableViewCellRect:[self.tableView rectForRowAtIndexPath:indexPath]
 */
+(void)setPicker2TableView:(UIDatePicker *)picker selectTableViewCellRect:(CGRect)cellRect;
@end


@implementation NWPickerUtils


+(void)setPicker2TableView:(UIDatePicker *)picker selectTableViewCellRect:(CGRect)cellRect
{

    //find the date picker size
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    
    //set the picker frame
    CGRect pickerRect = CGRectMake(0.0,
                                   cellRect.origin.y+cellRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    picker.frame = pickerRect;
}

+(void)setPickerInTableView:(UIDatePicker *)picker tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self setPicker2TableView:picker selectTableViewCellRect:[tableView rectForRowAtIndexPath:indexPath]];
    
    [UIView animateWithDuration: 0.4f
                     animations:^{
    tableView.contentSize=CGSizeMake(tableView.contentSize.width,tableView.contentSize.height+[picker sizeThatFits:CGSizeZero].height);
     }  completion:^(BOOL finished) {} ];
    
    NSLog(@"contentSize.width = %f,contentSize.height = %f",tableView.contentSize.width,tableView.contentSize.height);
}

+(void)dismissPicker:(UIScrollView *)tagView
{
    for (UIView *subview in [tagView subviews]) {
        if ([subview isKindOfClass:[UIDatePicker class]]) {
            [UIView animateWithDuration: 0.4f
                             animations:^{
            tagView.contentSize=CGSizeMake(tagView.contentSize.width, tagView.contentSize.height-[subview sizeThatFits:CGSizeZero].height);
            }  completion:^(BOOL finished) {} ];
                                 
            [subview removeFromSuperview];
        }
    }
}

@end
