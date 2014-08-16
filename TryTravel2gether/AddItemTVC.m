//
//  AddItemTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddItemTVC.h"
#import "Item.h"
#import "Itemcategory.h"
#import "CatInTrip.h"
#import "Day.h"
#import "Receipt+Calculate.h"
#import "Group.h"
#import "Group+TripGuys.h"

@interface AddItemTVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *qantity;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong,nonatomic) Itemcategory *selectedCategory;
@property (strong,nonatomic) Group *selectedGroupOrGuy;
@property (weak, nonatomic) IBOutlet UITableViewCell *categoryName;
@property (weak, nonatomic) IBOutlet UITableViewCell *groupCell;

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
    
    [self showGroupInfo:self.selectedGroupOrGuy];
}
#pragma mark - 事件
- (IBAction)save:(UIBarButtonItem *)sender {
    Item *item=[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                             inManagedObjectContext:self.managedObjectContext];
    item.name = self.name.text;
    item.price=[NSNumber numberWithDouble:[self.price.text doubleValue]];
    item.quantity=[NSNumber numberWithInteger:[self.qantity.text integerValue]];
    item.receipt=self.currentReceipt;
    if (!self.selectedCategory) {
        self.selectedCategory=[self getCategoryWithName:@"Uncategorized"];
    }
    item.catInTrip=[self getCatInTripWithCategory:self.selectedCategory AndTrip:self.currentReceipt.day.inTrip];
    item.itemIndex=self.currentReceipt.getNextItemSerialNumberInReceipt;
    item.group=self.selectedGroupOrGuy;
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Item in %@",self.class);
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

-(void)showGroupInfo:(Group *)group{
    if (group) {
        self.groupCell.textLabel.text=group.name;
        self.groupCell.imageView.image=[UIImage imageNamed:group.groupImageName];
        
        //大於一人再顯示群組中人員名單
        if (group.guysInTrip.count>1) {
            self.groupCell.detailTextLabel.text=[group guysNameSplitBy:@","];
        }else{
            self.groupCell.detailTextLabel.text=@"";
        }
    }else{
        self.groupCell.detailTextLabel.text=@"";
        self.groupCell.textLabel.text=NSLocalizedString(@"Unspecified",@"ActiveTips");
    }
}

#pragma mark - ▣ CRUD_CatInTrip+ItemCategory
-(CatInTrip *)getCatInTripWithCategory:(Itemcategory *)category AndTrip:(Trip *)trip{
    NSLog(@"Finding the CatInTrip in trip:%@, category:%@ ... @%@",trip.name,category.name,self.class);
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"CatInTrip" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(trip = %@) AND (category=%@)", trip,category];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"Can't Find.");
        return [self createCategoryInTrip:trip ByCategory:category];
    } else {
        NSLog(@"Done.");
        return objects[0];
    }
}
-(CatInTrip *)createCategoryInTrip:(Trip *)trip ByCategory:(Itemcategory *)category{
    CatInTrip *catInTrip=[NSEntityDescription insertNewObjectForEntityForName:@"CatInTrip"
                                             inManagedObjectContext:self.managedObjectContext];
    catInTrip.trip=trip;
    catInTrip.category=category;
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Create new Cat:%@ in Trip:%@ @AddItemTVC",category.name,trip.name);
    return catInTrip;
}
-(Itemcategory *)getCategoryWithName:(NSString *)name{
    NSLog(@"Finding the Itemcategory:%@ ... @%@",name,self.class);
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Itemcategory" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name=%@", name];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"Can't Find.");
        return [self createCategoryWithName:name];
    } else {
        NSLog(@"Done.");
        return objects[0];
    }
}
-(Itemcategory *)createCategoryWithName:(NSString *)name{
    Itemcategory *category=[NSEntityDescription insertNewObjectForEntityForName:@"Itemcategory"
                                                       inManagedObjectContext:self.managedObjectContext];
    category.name=name;
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Create new Itemcategory:%@ @%@",category.name,self.class);
    return category;
}



#pragma mark - ➤ Navigation：Segue Settings

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Select Category Segue From Add Item"]){
        NSLog(@"Setting %@ as a delegate of selectCategoryCDTVC",self.class);
        SelectCategoryCDTVC *selectCategoryCDTVC=[segue destinationViewController];
        selectCategoryCDTVC.managedObjectContext=self.managedObjectContext;
        selectCategoryCDTVC.selectedCategory=self.selectedCategory;
        selectCategoryCDTVC.delegate=self;
    }else if ([segue.identifier isEqualToString:@"Select Group Segue From Add Item"]){
        NSLog(@"Setting %@ as a delegate of selectGroupAndGuyCDTVC",self.class);
        SelectGroupAndGuyCDTVC *selectGroupAndGuyCDTVC=[segue destinationViewController];
        selectGroupAndGuyCDTVC.managedObjectContext=self.managedObjectContext;
        selectGroupAndGuyCDTVC.currentTrip=self.currentReceipt.day.inTrip;
        selectGroupAndGuyCDTVC.selectedGroup=self.selectedGroupOrGuy;
        selectGroupAndGuyCDTVC.delegate=self;
    }
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)theDoneButtonOnTheSelectCategoryCDTVCWasTapped:(SelectCategoryCDTVC *)controller{
    if (controller.selectedCategory) {
        self.selectedCategory=controller.selectedCategory;
        self.categoryName.textLabel.text=self.selectedCategory.name;
    }else{
        self.categoryName.textLabel.text=@"Uncategorized";
    }

    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)theGroupCellOnTheSelectGroupAndGuyCDTVCWasTapped:(SelectGroupAndGuyCDTVC *)controller{
    self.selectedGroupOrGuy=controller.selectedGroup;
    [self showGroupInfo:controller.selectedGroup];
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
