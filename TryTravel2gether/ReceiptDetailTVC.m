//
//  ReceiptDetailTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/3/25.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "ReceiptDetailTVC.h"
#import "Day.h"
#import "DayCurrency.h"
#import "Photo.h"
#import "Photo+Image.h"
#import "Receipt+Photo.h"
@interface ReceiptDetailTVC ()

@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateTimeFormatter;
@property Currency *currentCurrency;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UILabel *currencySign;

@property (weak, nonatomic) IBOutlet UITextField *totalPrice;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property NSIndexPath * actingCellIndexPath;
@property (strong,nonatomic) UIDatePicker *timePicker;
@property (nonatomic)  UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)  NSMutableArray *images;

@end

@implementation ReceiptDetailTVC
@synthesize timePicker=_timePicker;
@synthesize imagePicker=_imagePicker;
@synthesize images=_images;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //-----Date Formatter----------
    self.dateFormatter=[[NSDateFormatter alloc]init];
    self.timeFormatter=[[NSDateFormatter alloc]init];
    self.dateTimeFormatter=[[NSDateFormatter alloc]init];
    
    self.dateFormatter.dateFormat=@"yyyy/MM/dd";
    self.timeFormatter.dateFormat=@"HH:mm";
    self.dateTimeFormatter.dateFormat=[NSString stringWithFormat:@"%@ %@",self.dateFormatter.dateFormat,self.timeFormatter.dateFormat];
    
    //設定UITextFeild的delegate
    self.desc.delegate=self;
    self.totalPrice.delegate=self;
    
    //設定頁面初始的顯示狀態
    //-----顯示day資訊-----------
    [self configureTheCell];
}
#pragma mark - 事件
-(void)save:(id)sender{
    Day *selectedDay=[self getTripDayByDate:self.selectedDayString];
    self.receipt.desc = self.desc.text;
    self.receipt.total=[NSNumber numberWithDouble:[self.totalPrice.text doubleValue]];
    self.receipt.time=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
    self.receipt.day=selectedDay;
    
    self.receipt.dayCurrency=[self getDayCurrencyWithTripDay:selectedDay Currency:self.currentCurrency];
    //TODO: 存照片需要另外判斷
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Receipt in AddReceiptTVC");
    [self.delegate theSaveButtonOnTheAddReceiptWasTapped:self];
    NSLog(@"Telling the DayDetailTVC Delegate that Save was tapped on the DayDetailTVC");
}
- (void) pickerChanged:(UIDatePicker *)paramDatePicker {
    //find the current selected cell row in the table view
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    clickCell.detailTextLabel.text=[self.timeFormatter stringFromDate:paramDatePicker.date];
}

- (IBAction)takePhoto:(UIButton *)sender {
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    NSLog(@"show camera view @%@",self.class);
}
- (IBAction)existingOne:(UIButton *)sender {
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    NSLog(@"show photoLibrary view @%@",self.class);
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //1. 取得照片
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //2. 載入ImageView 延伸scrollView
    [self loadImageIntoScrollView:image];
    
    [self.images addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*! 載入ImageView，配合已存在的照片放置新位置並延伸scrollView為適當寬度
 */
-(void)loadImageIntoScrollView:(UIImage *)image{
    //1. 計算這次imageView大小位置，並把照片放進去
    NSInteger imgCount=[self.images count];
    double imgViewWidth=155;
    CGRect newImageRect=CGRectMake((imgViewWidth+5)*imgCount+5, 10, imgViewWidth, image.size.height/image.size.width*imgViewWidth);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:newImageRect];
    imgView.image=image;
    NSLog(@"loaded a image @%@",self.class);
    //2. 把imageView放進scrollView裡，並拉長scrollView
    [self.scrollView addSubview:imgView];
    CGSize scrollSize=CGSizeMake((imgViewWidth+5)*(imgCount+1), self.scrollView.frame.size.height);
    self.scrollView.contentSize=scrollSize; //要把scrollView拉大，才能scroll
    
}
/*!設定currentCurrency還有頁面相關顯示
 */
-(void)setAllCurrencyWithCurrency:(Currency *)currency{
    self.currentCurrency=currency;
    self.currency.detailTextLabel.text=currency.standardSign;
    self.currencySign.text=currency.sign;
}
-(void)setPickerFrame:(UIDatePicker *)picker WithIndexPath:(NSIndexPath *)indexPath{
    //find the current table view size
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    //find the date picker size
    CGSize pickerSize = [self.timePicker sizeThatFits:CGSizeZero];
    
    self.timePicker.frame = CGRectMake(0.0,
                                       cellRect.origin.y+cellRect.size.height,
                                       pickerSize.width,
                                       pickerSize.height);
}

/*!動畫設定，讓某大小之物件，動作流暢呈現至畫面最底
 */
-(void)animateToPlaceWithItemSize:(CGSize)itemSize{
    //下面這是動畫設定，讓動作流暢到位：[UIView animateWithDuration: animations: completion: ];
    [UIView animateWithDuration: 0.4f
                     animations:^{
                         //animations裡面是終點位置
                         
                         //TODO: picker的移位目前還是有問題，需測試tableviewcell很多行但picker從中間生成的時候
                         
                         
                         //先改變contentSize，底下需多撐一個picker的高度
                         self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+itemSize.height);
                         //如果加了picker之後的content高度大於螢幕高度，才需要移到最下面
                         if (self.tableView.contentSize.height>self.tableView.frame.size.height) {
                             self.tableView.contentOffset=CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height);
                         }
                         
                        
                     }
                     completion:^(BOOL finished) {} ];
}

#pragma mark - lazy instantiation

-(UIDatePicker *)timePicker{
    if(_timePicker == nil){
        _timePicker = [[UIDatePicker alloc] init];
        _timePicker.date=[self.dateFormatter dateFromString: self.selectedDayString];
        
        
        [_timePicker addTarget:self
                        action:@selector(pickerChanged:)
              forControlEvents:UIControlEventValueChanged];
        _timePicker.datePickerMode = UIDatePickerModeTime;
        //NSString *datetimeString=[self.dateCell.detailTextLabel.text stringByAppendingString:self.timeCell.detailTextLabel.text];
        _timePicker.date=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
        _timePicker.backgroundColor=[UIColor whiteColor];
    }
    return _timePicker;
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.delegate=self;
    }
    return _imagePicker;
}
-(NSMutableArray *)images{
    if (!_images) {
        _images=[NSMutableArray new];
    }
    return _images;
}
#pragma mark - Table view data source
-(void)configureTheCell{
    [self setAllCurrencyWithCurrency:self.receipt.dayCurrency.currency];
    self.totalPrice.text=[NSString stringWithFormat:@"%@", self.receipt.total];
    self.desc.text=self.receipt.desc;
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:self.receipt.day.date];
    self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate:self.receipt.time];
    self.selectedDayString=[self.dateFormatter stringFromDate: self.receipt.day.date];
//    for (int i=0; i<self.receipt.photos.count; i++) {
//        Photo *photo=self.receipt.photos[i];
//        UIImage *image=
//    }
    //TODO: 顯示的照片沒有照順序出現
    for (Photo * photo in self.receipt.photosOrdered) {
        UIImage *image=photo.image;
        [self loadImageIntoScrollView:image];   //要先load再add，不然位置會計算錯
        [self.images addObject:image];
    }
}
#pragma mark - ▣ CRUD_TripDay+DayCurrency
/*!以yyyy/MM/dd的日期字串取得本旅程中對應的Day，如果沒有這天，回傳nil
 */
-(Day *)getTripDayByDate:(NSString *)dateString{
    NSLog(@"Find the trip day:%@ in the current trip.",dateString);
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSDate *date= [self.dateFormatter dateFromString:dateString];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self.receipt.day.inTrip];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        return [self createDayInCurrentTripByDateString:date];
    } else {
        return objects[0];
    }
}
-(Day *)createDayInCurrentTripByDateString:(NSDate *)date{
    NSLog(@"Create the new day in the current trip.");
    
    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
                                             inManagedObjectContext:self.managedObjectContext];
    day.name=@"";
    day.date=date;
    day.inTrip=self.receipt.day.inTrip;
    
    NSLog(@"Create new Day in AddReceiptTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    return day;
}
-(DayCurrency *)getDayCurrencyWithTripDay:(Day *)tripDay Currency:(Currency *)currency{
    NSString *dateString=[ self.dateFormatter stringFromDate:tripDay.date];
    NSLog(@"Find the DayCurrency in trip:%@, date:%@, currency:%@ ...",tripDay.inTrip.name,dateString,currency.standardSign);
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"DayCurrency" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(tripDay = %@) AND (currency=%@)", tripDay,currency];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if ([objects count] == 0) {
        NSLog(@"Can't Find.");
        return [self createDayCurrencyWithTripDay:tripDay Currency:currency];
    } else {
        NSLog(@"Done.");
        return objects[0];
    }
}
-(DayCurrency *)createDayCurrencyWithTripDay:(Day *)tripDay Currency:(Currency *)currency{
    NSLog(@"Create the new DayCurrency");
    
    DayCurrency *dayCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"DayCurrency"
                                                             inManagedObjectContext:self.managedObjectContext];
    dayCurrency.tripDay=tripDay;
    dayCurrency.currency=currency;
    
    NSLog(@"Create new DayCurrency in DayCurrency+FindOneOrCreateNew");
    
    [self.managedObjectContext save:nil];  // write to database
    return dayCurrency;
}


#pragma mark - ➤ Navigation：Segue Settings

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Trip Day Segue From Receipt Detail"]) {
        NSLog(@"Setting AddReceiptTVC as a delegate of TripDaysTVC...");
        TripDaysTVC *TripDaysTVC=segue.destinationViewController;
        TripDaysTVC.delegate=self;
        
        TripDaysTVC.managedObjectContext=self.managedObjectContext;
        
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        TripDaysTVC.currentTrip=self.receipt.day.inTrip;
        TripDaysTVC.selectedDayString=self.selectedDayString;
    }else if([segue.identifier isEqualToString:@"Currency Segue From Receipt Detail"]){
        NSLog(@"Setting CurrencyCDTVC as a delegate of TripDaysTVC...");
        CurrencyCDTVC *currencyCDTVC=segue.destinationViewController;
        
        currencyCDTVC.delegate=self;
        currencyCDTVC.managedObjectContext=self.managedObjectContext;
        currencyCDTVC.selectedCurrency=self.currentCurrency;
        
    }
}

#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)dayWasSelectedInTripDaysTVC:(TripDaysTVC *)controller{
    self.selectedDayString=controller.selectedDayString;
    self.dateCell.detailTextLabel.text=controller.selectedDayString;
    //self.datePicker.date=[self.dateFormatter dateFromString:controller.selectedDayString];
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)currencyWasSelectedInCurrencyCDTVC:(CurrencyCDTVC *)controller{
    [self setAllCurrencyWithCurrency:controller.selectedCurrency];
    [controller.navigationController popViewControllerAnimated:YES];
}
#pragma mark 監測點選row時候的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    if (clickCell==self.timeCell) {
        bool hasBeTapped=NO;
        if(indexPath.row==self.actingCellIndexPath.row){
            hasBeTapped=YES;
        }
        if (hasBeTapped) {
            self.actingCellIndexPath=nil;
            //把剛剛加的picker高度扣回去
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-[self.timePicker sizeThatFits:CGSizeZero].height);
            [self.timePicker removeFromSuperview];

        }else{
            self.actingCellIndexPath=indexPath;
            [self setPickerFrame:self.timePicker WithIndexPath:indexPath];
            //add the picker to the view
            [self.view addSubview:self.timePicker];
            [self animateToPlaceWithItemSize:[self.timePicker sizeThatFits:CGSizeZero]];
        }
        // 想要改變cell高度，需要重新整理tableView，beginUpdates和endUpdates
        //[self.tableView beginUpdates];
        //[self.tableView endUpdates];
    }
}
////下面這個目前沒有使用
//#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height=self.tableView.rowHeight;
//    return height;
//}
@end
