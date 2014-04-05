//
//  SelectGuysTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/4/5.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "SelectGuysCDTVC.h"

@interface SelectGuysCDTVC ()


@property NSIndexPath *actingDateCellIndexPath;

@end

@implementation SelectGuysCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize delegate;
@synthesize actingDateCellIndexPath;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}


#pragma mark - FetchedResultsController

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Guy"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:NO
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing=YES;
    [self.tableView setEditing:YES animated:YES];
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Guys Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    Guy *guy = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = guy.name;
    return cell;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

}


#pragma mark - ➤ Navigation：Segue Settings

// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Add Guy Segue From Select GuysTVC"])
	{
        NSLog(@"Setting SelectGuysTVC as a delegate of AddGuyTVC");
        
        AddGuyTVC *addGuyTVC = segue.destinationViewController;
        addGuyTVC.delegate = self;
        /*
         已經在AddGuyTVC裡宣告了一個delegate（是AddGuyTVCDelegate）
         addGuyTVC.delegate=self的意思是：我要監控AddGuyCDTVC
         */
        
        addGuyTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
	}
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

#pragma mark - Delegation
/*
 .h檔案宣告時有@interface SelectGuysTVC : UITableViewController <AddGuyTVCDelegate>
 就要實作AddGuyTVCDelegate宣告的method
 */
-(void)theSaveButtonOnTheAddGuyWasTapped:(AddGuyTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
    
    
}

//TODO:done button還沒有作用






@end