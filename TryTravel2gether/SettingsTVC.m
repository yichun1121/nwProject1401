//
//  SettingsTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SettingsTVC.h"
#import "GuysCDTVC.h"
#import "CategoriesCDTVC.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC
@synthesize managedObjectContext=_managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - ➤ Navigation：Segue Settings

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
    if ([segue.identifier isEqualToString:@"Guys List Segue"])
    {
        NSLog(@"Setting GuysCDTVC @%@",self.class);
        GuysCDTVC *guysCDTVC = segue.destinationViewController;
        //NSLog(@"Setting TripsCDTVC as a delegate of GuysTVC");
        //guysTVC.delegate = self;
        //應該不用監控DaysTVC
        
        guysCDTVC.managedObjectContext = self.managedObjectContext;
        
    }else if ([segue.identifier isEqualToString:@"Category List Segue"]){
        NSLog(@"Setting CategoriesCDTVC @%@",self.class);
        CategoriesCDTVC *categoriesCDTVC=segue.destinationViewController;
        categoriesCDTVC.managedObjectContext=self.managedObjectContext;
    }else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
