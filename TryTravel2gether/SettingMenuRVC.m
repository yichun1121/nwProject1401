//
//  SettingMenuRVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/15.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SettingMenuRVC.h"
#import "TripsCDTVC.h"
#import "SidebarViewController.h"

@interface SettingMenuRVC ()

@end

#pragma mark Storyboard support，與SWRevealViewController中的名稱相同
//主頁front、左側rear、右側right
static NSString * const SWSegueRearIdentifier = @"sw_rear";
static NSString * const SWSegueFrontIdentifier = @"sw_front";
static NSString * const SWSegueRightIdentifier = @"sw_right";

@implementation SettingMenuRVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(SWRevealViewControllerSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:SWSegueFrontIdentifier]) {
        
        //這段連到TripsCDTVC前面的navigationController，所以要把TripsCDTVC找出來設managedObjectContext
        UINavigationController *navigationController=segue.destinationViewController;
        if ([navigationController.topViewController isKindOfClass:[TripsCDTVC class]]) {
            TripsCDTVC *tripsCDTVC=(TripsCDTVC *)navigationController.topViewController;
            tripsCDTVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"translate managedObjecContext to TripsCDTVC @%@",self.class);
        }
    }else if ([segue.identifier isEqualToString:SWSegueRearIdentifier]){
        if ([segue.destinationViewController isKindOfClass:[SidebarViewController class]]) {
            SidebarViewController *sidbarVC=segue.destinationViewController;
            sidbarVC.managedObjectContext=self.managedObjectContext;
            NSLog(@"translate managedObjecContext to SidebarViewController @%@",self.class);
        }
    }
    [super prepareForSegue:segue sender:sender];
}


@end
