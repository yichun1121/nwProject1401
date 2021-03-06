//
//  ItemsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/29.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ItemsCDTVC.h"
#import "Item.h"
#import "NWCustCellImageTitleSubDetail.h"
#import "Receipt+Calculate.h"
#import "DayCurrency.h"
#import "Currency.h"
#import "CatInTrip.h"
#import "Itemcategory.h"
#import "Itemcategory+Colorful.h"
#import "ReceiptPhotoVC.h"
#import "Item+Expend.h"

@interface ItemsCDTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnGallery;

@property (weak, nonatomic) IBOutlet UILabel *remaining;
@end

@implementation ItemsCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentReceipt=_currentReceipt;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;
@synthesize btnGallery=_btnGallery;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];

    //計算未設定剩餘款
    NSString *strCurrencySign=self.currentReceipt.dayCurrency.currency.sign;
    self.remaining.text=[NSString stringWithFormat:@"%@ %@",strCurrencySign,[self.currentReceipt getMoneyRemaining]];
    
    //如果receipt裡沒有照片，就不顯示照片按鈕
    if ([self.currentReceipt.photos count]<=0) {
        self.btnGallery.enabled=NO;
    }else{
        self.btnGallery.enabled=YES;
    }
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Item";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate=[NSPredicate predicateWithFormat:@"receipt=%@",self.currentReceipt];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"itemIndex"
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
    UINib* myCellNib = [UINib nibWithNibName:@"NWCustCellImageTitleSubDetail" bundle:nil];
    [self.tableView registerNib:myCellNib forCellReuseIdentifier:@"Cell"];
    
    //-----顯示未設定金額----------
    NSString *strCurrencySign=self.currentReceipt.dayCurrency.currency.sign;
    double remaining=[[self.currentReceipt getMoneyRemaining]doubleValue];
    if (remaining==0) {
        //未配置金額==0時，不顯示
        self.remaining.superview.hidden=YES;
    }else{
        self.remaining.text=[NSString stringWithFormat:@"%@ %g",strCurrencySign,remaining];
        self.remaining.superview.hidden=NO;
        self.remaining.textColor=[UIColor redColor];
    }
    //-----設定下一頁時的back button的字（避免本頁的title太長）-----------
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBackString_Items", @"NavigationBackString") style:UIBarButtonItemStylePlain target:nil action:nil];
}


#pragma mark - Table view data source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Cell";

    NWCustCellImageTitleSubDetail *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NWCustCellImageTitleSubDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    return cell;
}
/*!組合TableViewCell的顯示內容
 */
-(NWCustCellImageTitleSubDetail *)configureCell:(NWCustCellImageTitleSubDetail *)cell AtIndexPath:(NSIndexPath *)indexPath{
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    Item *item=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleTextLabel.text=item.name;
    if (item.group) {
        cell.alertSignGroup.hidden=YES;
    }else{
        cell.alertSignGroup.hidden=NO;
    }
    
    cell.subtitleTextLabel.text=[NSString stringWithFormat:@"%@ x %@",item.price,item.quantity];
    
    NSString *strCurrencySign=item.receipt.dayCurrency.currency.sign;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",strCurrencySign,item.totalPrice];

    
    cell.imageView.image=item.catInTrip.category.image;
    cell.imageView.backgroundColor=item.catInTrip.category.color;
    cell.imageView.layer.borderColor=[item.catInTrip.category.color CGColor];
    cell.imageView.layer.borderWidth=0;
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:4.0];
    
    return cell;
}

#pragma mark - ➤ Navigation：Segue Settings

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Add Item Segue From Item List"]) {
        NSLog(@"Setting %@ as a delegate of AddItemTVC",self.class);
        AddItemTVC *addItemTVC=[segue destinationViewController];
        addItemTVC.managedObjectContext=self.managedObjectContext;
        addItemTVC.currentReceipt=self.currentReceipt;
        addItemTVC.delegate=self;
    }else if([segue.identifier isEqualToString:@"Item Segue From ItemList"]){
        NSLog(@"Setting %@ as a delegate of ItemDetailTVC",self.class);
        //因為自己寫的tableview:didSelectRowAtIndexPath:裡傳來的sender是indexPath，不是一般的cell，所以不用從cell轉成indexPath。
        //（搜尋didSelectRowAtIndexPath可以看到）
        Item *selectedItem=[self.fetchedResultsController objectAtIndexPath:sender];
        ItemDetailTVC *itemDetailTVC=[segue destinationViewController];
        itemDetailTVC.managedObjectContext=self.managedObjectContext;
        itemDetailTVC.currentReceipt=self.currentReceipt;
        itemDetailTVC.currentItem=selectedItem;
        itemDetailTVC.delegate=self;
    }else if ([segue.identifier isEqualToString:@"Photo Gallery Segue From Item List"]){
        NSLog(@"Setting %@ as a delegate of ReceiptPhotoVC",self.class);
        ReceiptPhotoVC *addItemTVC=[segue destinationViewController];
        addItemTVC.currentReceipt=self.currentReceipt;
//        addItemTVC.delegate=self;
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
        //-----顯示未設定金額----------
        NSString *strCurrencySign=self.currentReceipt.dayCurrency.currency.sign;
        self.remaining.text=[NSString stringWithFormat:@"%@ %@",strCurrencySign,[self.currentReceipt getMoneyRemaining]];
        
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


#pragma mark - 5 steps: 設定編輯模式下僅可以移動cell位置
//TODO: Item要加index排序才有意義，所以現在還沒有做
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
// 3. 將編輯模式時cell左方的delete圖示變成空的（可是非編輯還是可以delete）
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
// 4. 回傳編輯模式時，cell需不需要縮排。因為將左方delete圖示清掉，所以cell選擇不縮排
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
// 5. 真正移動時的進入的method
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
}


#pragma mark - 事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Item Segue From ItemList" sender:indexPath];
}

#pragma mark - delegation
-(void)theSaveButtonOnTheAddItemWasTapped:(AddItemTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
    //-----顯示未設定金額----------
    NSString *strCurrencySign=self.currentReceipt.dayCurrency.currency.sign;
    self.remaining.text=[NSString stringWithFormat:@"%@ %@",strCurrencySign,[self.currentReceipt getMoneyRemaining]];
    
}
-(void)theSaveButtonOnItemDetailTVCWasTapped:(ItemDetailTVC *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
    //-----顯示未設定金額----------
    NSString *strCurrencySign=self.currentReceipt.dayCurrency.currency.sign;
    self.remaining.text=[NSString stringWithFormat:@"%@ %@",strCurrencySign,[self.currentReceipt getMoneyRemaining]];
}


@end
