//
//  AddGroupTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectGuysCDTVC.h"
#import "Trip.h"

@class AddGroupTVC;
@protocol AddGroupTVCDelegate <NSObject>
-(void)theSaveButtonOnTheAddGroupWasTapped:(AddGroupTVC *)controller;
@end
@interface AddGroupTVC : UITableViewController<UITextFieldDelegate,SelectGuysCDTVCDelegate>
@property NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)id<AddGroupTVCDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property Trip *currentTrip;




@end
