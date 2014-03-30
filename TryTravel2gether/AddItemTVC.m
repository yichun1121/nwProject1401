//
//  AddItemTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddItemTVC.h"
#import "Item.h"

@interface AddItemTVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *qantity;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end

@implementation AddItemTVC

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
    
    self.name.delegate=self;
    self.price.delegate=self;
    self.qantity.delegate=self;
}
#pragma mark - 事件
- (IBAction)save:(UIBarButtonItem *)sender {
    Item *item=[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                             inManagedObjectContext:self.managedObjectContext];
    item.name = self.name.text;
    item.price=[NSNumber numberWithDouble:[self.price.text doubleValue]];
    item.quantity=[NSNumber numberWithInteger:[self.qantity.text integerValue]];
    item.receipt=self.currentReceipt;
    
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Item in AddItemTVC");
    [self.delegate theSaveButtonOnTheAddItemWasTapped:self];
    NSLog(@"Telling the AddItem Delegate that Save was tapped on the %@",[self class]);
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    double total=[self.price.text doubleValue]*[self.qantity.text integerValue];
    self.totalPrice.text=[NSString stringWithFormat:@"%g",total];
}


#pragma mark - Table view data source
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
