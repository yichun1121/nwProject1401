//
//  AddGuyTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddGuyTVC;
@protocol AddGuyTVCDelegate <NSObject>
-(void)theSaveButtonOnTheAddGuyWasTapped:(AddGuyTVC *)controller;
@end

@interface AddGuyTVC : UITableViewController<UITextFieldDelegate>
@property NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)id<AddGuyTVCDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *guyName;




@end
