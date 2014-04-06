//
//  AddCategoryTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itemcategory.h"
@class AddCategoryTVC;
@protocol AddCategoryTVCDelegate <NSObject>

-(void)theSaveButtonOnTheAddCategoryWasTapped:(AddCategoryTVC *)controller;

@end
@interface AddCategoryTVC : UITableViewController<UITextFieldDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Itemcategory *selectedCategory;
@property (weak,nonatomic)id<AddCategoryTVCDelegate> delegate;

@end
