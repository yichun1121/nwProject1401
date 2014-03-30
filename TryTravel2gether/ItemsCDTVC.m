//
//  ItemsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ItemsCDTVC.h"
#import "Item.h"
#import "NWCustCellTitleSubDetail.h"
#import "Receipt+Calculate.h"
#import "DayCurrency.h"
#import "Currency.h"

@interface ItemsCDTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UILabel *remaining;
@end

@implementation ItemsCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentReceipt=_currentReceipt;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Item";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate=[NSPredicate predicateWithFormat:@"receipt=%@",self.currentReceipt];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                    ascending:YES
                                                                                     selector:@selector(localizedCaseInsensitiveCompare:)], nil];
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                     managedObjectContext:self.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [self performFetch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=self.currentReceipt.desc;
    //self.editing=YES;
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
    
    //-----註冊CustomCell----------
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellTitleSubDetail" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Item Cell"];
    
    //-----顯示未設定金額----------
    self.remaining.text=[NSString stringWithFormat:@"%g",[self.currentReceipt getMoneyIsNotSet]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Item Cell";

    NWCustCellTitleSubDetail *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellTitleSubDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(NWCustCellTitleSubDetail *)configureCell:(NWCustCellTitleSubDetail *)cell AtIndexPath:(NSIndexPath *)indexPath{
    Item *item=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextLabel.text=item.name;
    cell.subtitleTextLabel.text=[NSString stringWithFormat:@"%@ x %@",item.price,item.quantity];
    double totalPrice=[item.price doubleValue]*[item.quantity integerValue];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%g",totalPrice];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerWillChangeContent:controller];
    self.remaining.text=[NSString stringWithFormat:@"%g",[self.currentReceipt getMoneyIsNotSet]];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Item Segue From Item List"]) {
        
        NSLog(@"Setting %@ as a delegate of AddItemTVC",self.class);
        AddItemTVC *addItemTVC=[segue destinationViewController];
        addItemTVC.managedObjectContext=self.managedObjectContext;
        addItemTVC.currentReceipt=self.currentReceipt;
        addItemTVC.delegate=self;
    }
}

#pragma mark - Deleting（紅➖）+Inserting(綠➕）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the role object that was swiped
        Item *itemDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting %@(%@ %@)", itemDelete.name,itemDelete.receipt.dayCurrency.currency.standardSign,itemDelete.price);
        [self.managedObjectContext deleteObject:itemDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        self.remaining.text=[NSString stringWithFormat:@"%g",[self.currentReceipt getMoneyIsNotSet]];
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - 5 steps: 設定編輯模式下僅可以移動cell位置
// 須在self.editing=YES;情況下才有作用

// 1. 先設定cell為可編輯模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 2. 設定可以移動的row（可移動return YES，不可動return NO）
//Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
// 3. 將編輯模式時cell左方的delete圖示變成空的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
// 4. 回傳編輯模式時，cell需不需要縮排。因為將左方delete圖示清掉，所以cell選擇不縮排
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
// 5. 真正移動時的進入的method
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
}





#pragma mark - delegation
-(void)theSaveButtonOnTheAddItemWasTapped:(AddItemTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
    self.remaining.text=[NSString stringWithFormat:@"%g",[self.currentReceipt getMoneyIsNotSet]];
}

@end
