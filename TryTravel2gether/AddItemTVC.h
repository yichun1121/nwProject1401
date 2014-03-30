//
//  AddItemTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Receipt.h"

@class AddItemTVC;
@protocol AddItemTVCDelegate <NSObject>

-(void)theSaveButtonOnTheAddItemWasTapped:(AddItemTVC *)controller;

@end
@interface AddItemTVC : UITableViewController<UITextFieldDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) id<AddItemTVCDelegate> delegate;

@property (strong,nonatomic) Receipt *currentReceipt;
@end
