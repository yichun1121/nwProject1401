//
//  AddTripTVC.m
//  TryTravel2gether
//
//  Created by 葉小鴨與貓一拳 on 14/1/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddTripTVC.h"


#define kStartPicker 2  //startPicker在第2行
#define kEndPicker 4    //endPicker在第4行
/*! 展開Picker後的Cell高度
 */
static NSInteger sPickerCellHeight=162;

@interface AddTripTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AddTripTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter=_dateFormatter;

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //-----Date Formatter----------
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    //-----顯示當天的日期-----------
    self.startDate.detailTextLabel.text= [self.dateFormatter stringFromDate:[NSDate date]];
    self.endDate.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
}
-(void) save:(id)sender{
    NSLog(@"Telling the AddTripTVC Delegate that Save was tapped on the AddTripTVC");
    
    Trip *role = [NSEntityDescription insertNewObjectForEntityForName:@"Trip"
                                               inManagedObjectContext:self.managedObjectContext];
    
    role.name = self.tripName.text;
    
    [self.managedObjectContext save:nil];  // write to database
    
    //發射按下的訊號，讓有實做theSaveButtonOnTheAddTripTVCWasTapped這個method的程式（監聽add的程式）知道。
    [self.delegate theSaveButtonOnTheAddTripTVCWasTapped:self];
}
#pragma mark - 每次點選row的時候會做的事
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:不知道為什麼要用row判斷，不用row會錯
    bool hasBeTapped=(indexPath.row==self.actingDateCellIndexPath.row);
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickCell==self.startDate||clickCell==self.endDate) {
        //如果剛剛點了同個DateCell的話就代表想要關掉picker，故把actingDateCellIndexPath設nil
        if (hasBeTapped) {
            self.actingDateCellIndexPath=nil;
        }else{
            self.actingDateCellIndexPath=indexPath;
        }
        // 為了讓picker展開或關閉，需要重新整理tableView，beginUpdates和endUpdates
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark 負責長cell的高度（每次會因為tableView beginUpdates和endUpdates重畫）
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat result=self.tableView.rowHeight;
    if (indexPath.row==kStartPicker||indexPath.row==kEndPicker) {
        if (indexPath.row-1==self.actingDateCellIndexPath.row) {
        /*如果正在執行的actingDateCell是正在畫的這行的上一行
        代表點選了dateCell，而現在正要把picker展開回原始高度。*/
            self.actingPickerCellIndexPath=indexPath;
            result=sPickerCellHeight;
        }else{
        /*否則只要是pickerCell高度就會縮成0。
         */
            result=0;
        }
    }
    return result;
}

@end
