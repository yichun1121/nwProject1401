//
//  ExportCSVFileCDTVC.h
//  TryTravel2gether
//
//  Created by vincent on 2014/8/22.
//  Copyright (c) 2014年 NW. All rights reserved.
//
#import "CoreDataTableViewController.h"

@interface ExportCSVFileCDTVC : UIViewController<UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *toRecipients;
@property (weak, nonatomic) IBOutlet UIButton *sendMail;

@end
