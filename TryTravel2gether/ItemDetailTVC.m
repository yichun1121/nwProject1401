//
//  ItemDetailTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/10.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ItemDetailTVC.h"
#import "Itemcategory.h"
#import "CatInTrip.h"
#import "Day.h"

@interface ItemDetailTVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *qantity;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong,nonatomic) Itemcategory *selectedCategory;
@property (weak, nonatomic) IBOutlet UITableViewCell *categoryName;

@end

@implementation ItemDetailTVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setItemDetail:self.currentItem];
}

-(void)setItemDetail:(Item *)item{
    self.name.text=item.name;
    self.price.text=[NSString stringWithFormat:@"%@", item.price] ;
    self.qantity.text=[NSString stringWithFormat:@"%@", item.quantity] ;
    self.totalPrice.text=[NSString stringWithFormat:@"%f", [item.price doubleValue]*[item.quantity intValue]] ;

    self.selectedCategory=item.catInTrip.category;
    self.categoryName.textLabel.text=item.catInTrip.category.name;
}

#pragma mark - 事件
- (IBAction)save:(UIBarButtonItem *)sender{
    
    self.currentItem.name = self.name.text;
    self.currentItem.price=[NSNumber numberWithDouble:[self.price.text doubleValue]];
    self.currentItem.quantity=[NSNumber numberWithInteger:[self.qantity.text integerValue]];
    if (!self.selectedCategory) {
        self.selectedCategory=[super getCategoryWithName:@"Uncategorized"];
    }
    self.currentItem.catInTrip=[super getCatInTripWithCategory:self.selectedCategory AndTrip:self.currentItem.receipt.day.inTrip];
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save Item @%@",self.class);
    [self.delegate theSaveButtonOnTheAddItemWasTapped:self];
    NSLog(@"Telling the Delegate that Save was tapped on the @%@",self.class);
}
-(IBAction)textFieldEditingChanged:(UITextField *)sender{
    [super textFieldEditingChanged:sender];
}


#pragma mark - ➤ Navigation：Segue Settings

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Category Segue From Item Detail"]){
        NSLog(@"Setting %@ as a delegate of selectCategoryCDTVC",self.class);
        SelectCategoryCDTVC *selectCategoryCDTVC=[segue destinationViewController];
        selectCategoryCDTVC.managedObjectContext=self.managedObjectContext;
        selectCategoryCDTVC.selectedCategory=self.selectedCategory;
        selectCategoryCDTVC.delegate=self;
    }
}

//#pragma mark - delegation
//#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
////要在viewDidLoad裡加上textField的delegate=self，才監聽的到
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
@end
