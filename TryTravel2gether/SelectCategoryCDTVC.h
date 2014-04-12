//
//  SelectCategoryCDTVC.h
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/7.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CategoriesCDTVC.h"
#import "Itemcategory.h"
#import "AddCategoryTVC.h"
@class SelectCategoryCDTVC;
@protocol SelectCategoryCDTVCDelegate <NSObject>

-(void)theDoneButtonOnTheSelectCategoryCDTVCWasTapped:(SelectCategoryCDTVC *)controller;

@end
@interface SelectCategoryCDTVC :CategoriesCDTVC<AddCategoryTVCDelegate>

@property (strong,nonatomic)Itemcategory *selectedCategory;
@property (weak,nonatomic) id<SelectCategoryCDTVCDelegate> delegate;

@end
