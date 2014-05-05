//
//  NWKeyboardUtils.h
//  TryTravel2gether
//
//  Created by vincent on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWKeyboardUtils : NSObject
/*! 遞迴尋找底下所有的Textfeild，當UITextField不是游標焦點時關閉keyboard
 */
+(void)dismissKeyboard4TextField:(UIView *) tagView;
@end
