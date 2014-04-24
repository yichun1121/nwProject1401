//
//  TripsCDTVCWithSidebar.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/24.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripsCDTVCWithSidebar.h"
#import "SettingMenuRVC.h"

@interface TripsCDTVCWithSidebar ()

@end

@implementation TripsCDTVCWithSidebar


- (void)viewDidLoad
{
    [super viewDidLoad];
    //------Set Sidebar Menu--------
    [self setSidebarMenuAction];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
