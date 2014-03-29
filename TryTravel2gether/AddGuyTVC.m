//
//  AddGuyTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddGuyTVC.h"
#import "Guy.h"

@implementation AddGuyTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.guyName.delegate=self; //要加delegate=self，監聽textfield，才能在return時收鍵盤（textFieldShouldReturn）
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)save:(UIBarButtonItem *)sender {
    
    Guy *guy = [NSEntityDescription insertNewObjectForEntityForName:@"Guy"
                                             inManagedObjectContext:self.managedObjectContext];
    
    guy.name = self.guyName.text;
    
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheAddGuyWasTapped:self];
}

#pragma mark - delegation
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
