//
//  AddGroupTVC.h
//  TryTravel2gether
//
//  Created by apple on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGuyTVC.h"
#import "Trip.h"

@class AddGroupTVC;
@protocol AddGroupTVCDelegate <NSObject>
-(void)theSaveButtonOnTheAddGroupWasTapped:(AddGroupTVC *)controller;
@end
@interface AddGroupTVC : UITableViewController<UITextFieldDelegate,NSFetchedResultsControllerDelegate,AddGuyTVCDelegate>
@property NSManagedObjectContext *managedObjectContext;
@property (weak,nonatomic)id<AddGroupTVCDelegate> delegate;
@property (strong, nonatomic) NSFetchedResultsController *
fetchedResultsController;

@property Trip *currentTrip;




@end
