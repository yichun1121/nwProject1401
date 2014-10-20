//
//  NWAdShiftTableViewController.m
//  TryTravel2gether
//
//  Created by vincent on 2014/7/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWAdShiftTableViewController.h"

@interface NWAdShiftTableViewController ()
@property BOOL isMoveForADAlready;
@end

@implementation NWAdShiftTableViewController

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
#pragma mark - Table view set AdMob banner

// 需要廣告的時候把下面整段的註解取消
// 還要把GoogleAdMobileLibs資料夾裝回來
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (!self.isMoveForADAlready) {
//        NSLog(@"before content:%f",self.tableView.contentSize.height);
//        NSLog(@"before frame:%f",self.tableView.frame.size.height);
//        //-----self.tableView.frame 的高度剪掉AdMob Banner高度-------(讓Banner不會擋到TableView的資訊)
////        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x
////                                            , self.tableView.frame.origin.y
////                                            , self.tableView.frame.size.width
////                                            , self.tableView.frame.size.height-100)];
////    [self.tableView setBounds:CGRectMake(self.tableView.bounds.origin.x
////                                        , self.tableView.bounds.origin.y
////                                        , self.tableView.bounds.size.width
////                                        , self.tableView.bounds.size.height-100)];
//
//
//        
//        //最後是要增加contentSize，把AD的高度也加入contentSize中
//        [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width
//                                            , self.tableView.contentSize.height+50)];
//    
//        self.isMoveForADAlready=YES;
//    }
//    NSLog(@"after content:%f",self.tableView.contentSize.height);
//    NSLog(@"after frame:%f",self.tableView.frame.size.height);
//}

@end
