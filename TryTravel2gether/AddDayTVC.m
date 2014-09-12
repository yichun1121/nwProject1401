//
//  AddDayTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddDayTVC.h"
#import "Day.h"
#import "Trip+Days.h"
#import "NWKeyboardUtils.h"
#import "NWPickerUtils.h"
#import "NWUIScrollViewMovePostition.h"

@interface AddDayTVC ()
@property (nonatomic)  NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDateFormatter *dateFormatter_GMT;
@property (nonatomic)  UIDatePicker *datePicker;
@property NSIndexPath *actingDateCellIndexPath;
@end

@implementation AddDayTVC
@synthesize dateFormatter=_dateFormatter;
@synthesize dateFormatter_GMT=_dateFormatter_GMT;
@synthesize datePicker=_datePicker;

#pragma mark - lazy instantiation
-(NSDateFormatter *)dateFormatter_GMT{
    if (!_dateFormatter_GMT) {
        _dateFormatter_GMT=[[NSDateFormatter alloc]init];
        _dateFormatter_GMT.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        self.dateFormatter_GMT.dateFormat=@"yyyy/MM/dd";
    }
    return _dateFormatter_GMT;
}
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    return _dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=self.currentTrip.name;
    
    NSString *todayDateString=[self.dateFormatter_GMT stringFromDate:[NSDate date]];
    [self showResultOfTheDateString:todayDateString];
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
    
    self.dayName.delegate=self; //要加delegate=self，監聽textfield，才能在return時收鍵盤（textFieldShouldReturn）
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - datePicker的getter，呼叫時才建立datePicker
-(UIDatePicker *)datePicker{
    
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode=UIDatePickerModeDate;
        _datePicker.backgroundColor=[UIColor whiteColor];
    }
    
    return _datePicker;
}

-(void) showResultOfTheDateString:(NSString *)date{
    if ([self.currentTrip hadThisDateWithUTC:date]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.dayResultString.textLabel.text=NSLocalizedString(@"TripDayValidate_ExistedDay",@"ValueValidate");
    }else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.dayResultString.textLabel.text=@"";
    }
}


#pragma mark - PickerChange事件
- (void)pickerChanged{
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:self.datePicker.date];
    NSString *dateString=[self.dateFormatter_GMT stringFromDate:self.datePicker.date];
    [self showResultOfTheDateString:dateString];
    
}

#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    //每次Segue時清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
    //點選Segue時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    if (clickedCell==self.dateCell) {
        BOOL hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
        if (hasBeTapped) {

            self.actingDateCellIndexPath=nil;
        }else{
            self.actingDateCellIndexPath=indexPath;
            
            [NWPickerUtils setPickerInTableView:self.datePicker tableView:tableView didSelectRowAtIndexPath:indexPath];
            [self.view addSubview:self.datePicker];
            [NWUIScrollViewMovePostition autoContentOffsetToTableViewCenter:tableView didSelectRowAtIndexPath:indexPath withTagItemSize:[self.datePicker sizeThatFits:CGSizeZero]];
            
            [self.datePicker addTarget:self action:@selector(pickerChanged) forControlEvents:UIControlEventValueChanged];

        }
    }
}

- (IBAction)save:(UIBarButtonItem *)sender {
    NSLog(@"Telling the AddDayTVC Delegate that Save was tapped on the AddDayTVC");
    
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    day.name = self.dayName.text;
    day.inTrip=self.currentTrip;
    day.date=[self.dateFormatter_GMT dateFromString:self.dateCell.detailTextLabel.text];
    
    NSLog(@"Save new Day in AddDayTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheAddDayWasTapped:self];
}

#pragma mark - delegation
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//開始編輯textField時做的事
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
}


@end
