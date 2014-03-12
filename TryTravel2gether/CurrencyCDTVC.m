//
//  CurrencyCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/12.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "CurrencyCDTVC.h"

@interface CurrencyCDTVC ()

@end

@implementation CurrencyCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize delegate;
@synthesize selectedCurrency=_selectedCurrency;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

#pragma mark - FetchedResultsController
-(void)setupFetchedResultsController{
    //1. 設定entity的名稱
    NSString *entityName=@"Currency";
    
    //2. 建立Request
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //3. 設定Filter
    //NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inTrip=%@",self.currentTrip];
    //request.predicate=predicate;
    
    //4. 排序
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    //5. Fetch it
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:Nil cacheName:nil];
    
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    [self performFetch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
#pragma mark - 一行一行的把資料填進畫面裡
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"Currency Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Currency *currency=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=currency.name;
    cell.detailTextLabel.text=currency.standardSign;

    if (currency == self.selectedCurrency) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Currency *currency=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedCurrency=currency;
    [self.delegate currencyWasSelectedInCurrencyCDTVC:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
