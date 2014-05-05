//
//  NWUIScrollViewMovePostition.h
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWUIScrollViewMovePostition : NSObject

/*!
 自動判斷tableView點選到的cell高加上要長成的item高是否有超過畫面的
 即判斷點選的cell與加上item的位置在畫面範圍內。
 有的話將畫面移到接近畫面中間的位置。
 coefficient =44.0+frameHeight/5; 44.0為navigationBar的高度
 */
+(void)autoContentOffsetToTableViewCenter:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withTagItemSize:(CGSize)itemSize;

@end
