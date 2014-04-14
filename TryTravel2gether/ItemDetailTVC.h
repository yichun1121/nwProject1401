//
//  ItemDetailTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/10.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemDetailTVC.h"
#import "AddItemTVC.h"
//@class ItemDetailTVC;
//@protocol ItemDetailTVCDelegate <NSObject>
//-(void)theSaveButtonOnItemDetailTVCWasTapped:(ItemDetailTVC *)controller;
//@end
@interface ItemDetailTVC :AddItemTVC

@property (strong,nonatomic)Item *currentItem;

@end
