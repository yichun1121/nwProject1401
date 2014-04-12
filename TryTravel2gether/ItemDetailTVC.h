//
//  ItemDetailTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/10.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@class ItemDetailTVC;
@protocol ItemDetailTVCDelegate <NSObject>

-(void)theSaveButtonOnItemDetailTVCWasTapped:(ItemDetailTVC *)controller;

@end
@interface ItemDetailTVC : UITableViewController

@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic)Item *currentItem;
@property (weak,nonatomic)id<ItemDetailTVCDelegate> delegate;
@end
