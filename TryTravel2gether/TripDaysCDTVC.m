//
//  TripDaysCDTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripDaysCDTVC.h"
#import "Day.h"
#import "Day+TripDay.h"

@interface TripDaysCDTVC ()
@property NSDateFormatter *dateFormatter;
@end

@implementation TripDaysCDTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize delegate;
@synthesize selectedDayString;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

-(void)setupFetchedResultsController{
    //1. 設定entity的名稱
    NSString *entityName=@"Day";
    
    //2. 建立Request
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //3. 設定Filter
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inTrip=%@",self.currentTrip];
    request.predicate=predicate;
    
    //4. 排序
    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    //5. Fetch it
    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:Nil cacheName:nil];
    
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    [self performFetch];
}

-(void)viewDidLoad{
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
}

#pragma mark - 一行一行的把資料填進畫面裡
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"Trip Day Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=[day DayNumberStringOfTripdayInTrip];
    cell.detailTextLabel.text=[self.dateFormatter stringFromDate:day.date];
    NSString *cellDayString=[self.dateFormatter stringFromDate:day.date];
    if ([cellDayString isEqualToString: self.selectedDayString]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
    Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedDayString=[self.dateFormatter stringFromDate:day.date];
    [self.delegate dayWasSelectedInTripDaysCDTVC:self];
}
@end
