//
//  SidebarViewController.h
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWAdShiftTableViewController.h"

@interface SidebarViewController : NWAdShiftTableViewController

@property (strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@end
