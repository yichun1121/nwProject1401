
//
//  TripDaysTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/19.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "TripDaysTVC.h"
#import "Day.h"
#import "Day+TripDay.h"
#import "Trip+Days.h"

@interface TripDaysTVC ()
@property NSDateFormatter *dateFormatter;
@property NSIndexPath *actingDateCellIndexPath;
@property (strong, nonatomic) UIDatePicker *datePicker;
//只要是程式生的ui（不是畫在storyboard裡的）如果才生成就不見，就考慮用strong
@end

@implementation TripDaysTVC
@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize delegate;
@synthesize selectedDayString;
@synthesize actingDateCellIndexPath;
@synthesize datePicker=_datePicker;

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setupFetchedResultsController];
//}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    //1. 設定entity的名稱
    //    NSString *entityName=@"Day";
    NSString *entityName = @"Day"; // Put your entity name here
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - 建立Request
    //    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:entityName];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchBatchSize:20];
    
    //3. 設定Filter
    //    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inTrip=%@",self.currentTrip];
    //    request.predicate=predicate;
    request.predicate = [NSPredicate predicateWithFormat:@"inTrip = %@",self.currentTrip];
    
    //4. 排序
    //    request.sortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(localizedStandardCompare:)]];
    NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptors]];
    //5. Fetch it
    //    self.fetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:Nil cacheName:nil];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
	return _fetchedResultsController;
}

-(UIDatePicker *)datePicker{
    if(_datePicker == nil){
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.date=[self.dateFormatter dateFromString: self.selectedDayString];
        
        [_datePicker addTarget:self
                   action:@selector(pickerChanged:)
         forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor=[UIColor whiteColor];
    }
    return _datePicker;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = [[self.fetchedResultsController sections] count];
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
    //要多長一行cell用來寫other day
	return count+1;
}


#pragma mark - 一行一行的把資料填進畫面裡
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"Trip Day Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell=[self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}

/*!組合TableViewCell的顯示內容
 */
-(UITableViewCell *)configureCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
	NSInteger count = [sectionInfo numberOfObjects];
    if (indexPath.row<count) {
        //顯示已存在的旅遊日子
        Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text=[day DayNumberStringOfTripdayInTrip];
        cell.detailTextLabel.text=[self.dateFormatter stringFromDate:day.date];
        NSString *cellDayString=[self.dateFormatter stringFromDate:day.date];
        if ([cellDayString isEqualToString: self.selectedDayString]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else{
        //顯示尚未新增的旅遊日：Other Day那行。
        //（從self.selectedDayString來，當日或是剛才點選的日期）
        cell.textLabel.text=@"other day";
        BOOL tripHadTheSelectedDay=[self.currentTrip hadThisDate:[self.dateFormatter dateFromString:self.selectedDayString]];
        if (tripHadTheSelectedDay) {
            //若selectedDayString為已存在的旅遊日（ex旅遊當下）則因為上面的旅遊日已勾，所以不顯示
            cell.detailTextLabel.text=@"PUSH";
            cell.accessoryType=UITableViewCellAccessoryNone;
        }else{
            //若selectedDayString不在旅遊日當中，則會勾選並顯示日期
            cell.detailTextLabel.text=self.selectedDayString;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}


#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
	NSInteger count = [sectionInfo numberOfObjects];
    //indexPath.row<count代表選擇的是既定日期
    if (indexPath.row<count) {
        
        //UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
        Day *day=[self.fetchedResultsController objectAtIndexPath:indexPath];
        self.selectedDayString=[self.dateFormatter stringFromDate:day.date];
        
        [self.delegate dayWasSelectedInTripDaysTVC:self];
    }else{
        //點選PUSH那行
        bool hasBeTapped=NO;
        if (indexPath.row==self.actingDateCellIndexPath.row) {
            hasBeTapped=YES;
        }
        
        if (hasBeTapped) {
            self.actingDateCellIndexPath=nil;
            //selectedDayString在pickerChanged的時候就設好了
            //self.selectedDayString=clickCell.detailTextLabel.text;
            
            //把剛剛加的picker高度扣回去
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-[self.datePicker sizeThatFits:CGSizeZero].height);
            [self.datePicker removeFromSuperview];
            
            [self.delegate dayWasSelectedInTripDaysTVC:self];

        }else{
            self.actingDateCellIndexPath=indexPath;
            UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
            clickCell.detailTextLabel.text=self.selectedDayString;

            [self setPickerFrame:self.datePicker WithIndexPath:indexPath];
            //add the picker to the view
            [self.view addSubview:self.datePicker];
            [self animateToPlaceWithItemSize:[self.datePicker sizeThatFits:CGSizeZero]];
        }
    }
}

-(void)setPickerFrame:(UIDatePicker *)picker WithIndexPath:(NSIndexPath *)indexPath{
    //find the current table view size
    CGRect screenRect = [self.view bounds];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    //find the date picker size
    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
    
    //set the picker frame
    NSLog(@"screenRect.y=%f,lastcell.y=%f",screenRect.origin.y,cellRect.origin.y);
    CGRect pickerRect = CGRectMake(0.0,
                                   cellRect.origin.y+cellRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    self.datePicker.frame = pickerRect;
}

/*!動畫設定，讓某大小之物件，動作流暢呈現至畫面最底
 */
-(void)animateToPlaceWithItemSize:(CGSize)itemSize{
    //下面這是動畫設定，讓動作流暢到位：[UIView animateWithDuration: animations: completion: ];
    [UIView animateWithDuration: 0.4f
                     animations:^{
                         //animations裡面是終點位置
                         //先改變contentSize，底下需多撐一個picker的高度
                         self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+itemSize.height);
                         //如果加了picker之後的content高度大於螢幕高度，才需要移到最下面
                         if (self.tableView.contentSize.height>self.tableView.frame.size.height) {
                             self.tableView.contentOffset=CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished) {} ];
}

- (void) pickerChanged:(UIDatePicker *)paramDatePicker {
    //find the current selected cell row in the table view
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    clickCell.detailTextLabel.text=[self.dateFormatter stringFromDate:paramDatePicker.date];
    self.selectedDayString=clickCell.detailTextLabel.text;
    //TODO: 如果選了Picker日期，但是沒有點上方的cell而直接上一頁，就無法設定時間
}
@end
