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

@interface AddDayTVC ()
@property NSDateFormatter *dateFormatter;
@property (nonatomic)  UIDatePicker *datePicker;
@property NSIndexPath *actingDateCellIndexPath;
@end

@implementation AddDayTVC
@synthesize datePicker=_datePicker;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=self.currentTrip.name;

    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    
    [self showResultOfTheDate:[NSDate date]];
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
        _datePicker=[UIDatePicker new];

//        _datePicker.backgroundColor=[UIColor redColor];
//        _datePicker.alpha=0;
        
        CGRect screenRect=self.view.bounds; //要使用bounds，不能用frame
        float picker_height=_datePicker.frame.size.height;
        float picker_width=_datePicker.frame.size.width;
        CGRect rect=CGRectMake(0.0, screenRect.origin.y+screenRect.size.height-picker_height, picker_width, picker_height);
        
        //CGRect rect=CGRectMake(screenRect.origin.x, screenRect.origin.y, picker_width, picker_height);

        
        _datePicker=[[UIDatePicker alloc]initWithFrame:rect];
        [_datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _datePicker;
}

-(void) showResultOfTheDate:(NSDate *)date{
    if ([self.currentTrip hadThisDate:date]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.dayResultString.textLabel.text=@"Existed Day";
    }else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.dayResultString.textLabel.text=@"";
    }
}


#pragma mark - PickerChange事件
- (IBAction)pickerChanged:(UIDatePicker *)sender {
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:sender.date];

    [self showResultOfTheDate:sender.date];
//    if ([self.currentTrip hadThisDate:sender.date]) {
//        self.navigationItem.rightBarButtonItem.enabled=NO;
//        self.dayResultString.textLabel.text=@"Existed Day";
//    }else{
//        self.navigationItem.rightBarButtonItem.enabled=YES;
//        self.dayResultString.textLabel.text=@"";
//    }
    
}

#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickedCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickedCell==self.dateCell) {
        BOOL hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
        if (hasBeTapped) {
            [self.datePicker removeFromSuperview];
            self.actingDateCellIndexPath=nil;
        }else{
            self.actingDateCellIndexPath=indexPath;
            self.datePicker.datePickerMode=UIDatePickerModeDate;
            [self.tableView addSubview:self.datePicker];
        }
    }
}

- (IBAction)save:(UIBarButtonItem *)sender {
    NSLog(@"Telling the AddDayTVC Delegate that Save was tapped on the AddDayTVC");
    
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    day.name = self.dayName.text;
    day.inTrip=self.currentTrip;
    day.date=[self.dateFormatter dateFromString:self.dateCell.detailTextLabel.text];
    
    NSLog(@"Save new Day in AddDayTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheAddDayWasTapped:self];
}

#pragma mark - delegation
//監測UITextFeild事件，按下return的時候會收鍵盤
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
