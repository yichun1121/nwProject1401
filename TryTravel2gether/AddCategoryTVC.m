//
//  AddCategoryTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddCategoryTVC.h"

@interface AddCategoryTVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;

@end

@implementation AddCategoryTVC
@synthesize managedObjectContext,selectedCategory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.delegate=self;
}
#pragma mark - 事件
-(IBAction)save:(id)sender{
    Itemcategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Itemcategory"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    category.name = self.name.text;

    
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Receipt in AddReceiptTVC");
    [self.delegate theSaveButtonOnTheAddCategoryWasTapped:self];
    
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view set AdMob banner
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //-----self.tableView.frame 的高度剪掉AdMob Banner高度-------(讓Banner不會擋到TableView的資訊)
    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x
                                        , self.tableView.frame.origin.y
                                        , self.tableView.frame.size.width
                                        , self.tableView.frame.size.height-50)];
}

@end
