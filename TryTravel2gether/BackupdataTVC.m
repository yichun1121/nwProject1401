//
//  BackupdataCDTVC.m
//  TryTravel2gether
//
//  Created by vincent on 2014/8/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "BackupdataTVC.h"
#import "SWRevealViewController.h"
#import "nwAppDelegate.h"
#import "NWGoogleDriveBackupdataTVC.h"

@interface BackupdataTVC ()

@end

@implementation BackupdataTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize nwApp=_nwApp;

-(nwAppDelegate *) nwApp{
    if(_nwApp == NULL){
        _nwApp=(nwAppDelegate *) [[UIApplication  sharedApplication] delegate];
    }
    return _nwApp;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //------Set Sidebar Menu--------
    [self setSidebarMenuAction];
  
}



#pragma mark - Table view data source

-(void)setSidebarMenuAction{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
#pragma mark 在sidebar menu下讓delete功能正常
    self.revealViewController.panGestureRecognizer.delegate = self;
    // Set the gesture （在下面delegation的地方）
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark - ➤ Navigation：Segue Settings

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"Add Cat Segue From Cat List"]) {
////        NWGoogleDriveBackupdataTVC * nwgoogleDriveBackupdataTVC=segue.destinationViewController;
////        nwgoogleDriveBackupdataTVC.delegate=self;
////        nwgoogleDriveBackupdataTVC.managedObjectContext=self.managedObjectContext;
//    }
//}





@end
