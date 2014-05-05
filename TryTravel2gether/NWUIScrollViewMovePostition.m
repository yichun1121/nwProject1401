//
//  NWUIScrollViewMovePostition.m
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWUIScrollViewMovePostition.h"

@implementation NWUIScrollViewMovePostition

+(void)autoContentOffsetToTableViewCenter:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withTagItemSize:(CGSize)itemSize
{

    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    CGFloat itemHeight = cellRect.size.height+itemSize.height;
    CGFloat  movePostitionY= cellRect.origin.y+cellRect.size.height;
    CGFloat itemPostitionPoint = cellRect.origin.y+itemHeight;
    CGFloat frameHeight = tableView.frame.size.height;
    CGFloat coefficient =44.0+frameHeight/5;
    
    //自動判斷tableView點選到的cell高加上要長成的item高是否有超過畫面，即判斷點選的cell與加上item的位置在畫面範圍內。
    
    if (itemHeight > frameHeight || itemPostitionPoint>frameHeight){
        [UIView animateWithDuration: 0.4f
                         animations:^{
         tableView.contentOffset=CGPointMake(0, frameHeight-movePostitionY-coefficient);
                             
         }  completion:^(BOOL finished) {} ];

    }
   }

@end
