//
//  ReceiptsCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/16.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ReceiptsCDTVC.h"

@interface ReceiptsCDTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@end

@implementation ReceiptsCDTVC

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize currentDay=_currentDay;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultController];
}

#pragma mark - FetchedResultsController

-(void)setupFetchedResultController{
    
    NSString *entityName=@"Receipt";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@",entityName);
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    request.predicate=[NSPredicate predicateWithFormat:@"day=%@",self.currentDay];
    
    request.sortDescriptors=[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"time"
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
    
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"Receipt Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Receipt *receipt=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=receipt.desc;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",receipt.total];
    return cell;
}

@end
