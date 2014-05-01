//
//  AddReceiptTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/1/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddReceiptTVC.h"
#import "Trip.h"
#import "TripDaysTVC.h"
#import "DayCurrency.h"
#import "Currency.h"


@interface AddReceiptTVC ()
@property NSDateFormatter *dateFormatter;
@property NSDateFormatter *timeFormatter;
@property NSDateFormatter *dateTimeFormatter;
@property Currency *currentCurrency;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UILabel *currencySign;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;

@property NSIndexPath * actingCellIndexPath;
@property (nonatomic)  UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic)  NSMutableArray *images;
@end

@implementation AddReceiptTVC
@synthesize delegate;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize dateFormatter=_dateFormatter;
@synthesize timeFormatter=_timeFormatter;
@synthesize dateTimeFormatter=_dateTimeFormatter;
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
    
    //設定UITextFeild的delegate（按return縮keyboard）
    self.desc.delegate=self;
    self.totalPrice.delegate=self;
    //設定scrollView的delegate（scroll功能）
    self.scrollView.delegate=self;
    
    //設定頁面初始的顯示狀態
    [self showDefaultDateValue];
    [self setAllCurrencyWithCurrency:self.currentTrip.mainCurrency];
    

}
/*! 顯示預設日期，如果沒有指定的話預設顯示當天的Date和Time
 */
-(void)showDefaultDateValue{
    if (self.selectedDayString) {
        self.dateCell.detailTextLabel.text=self.selectedDayString;
    }else{
        self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:[NSDate date]];
        self.selectedDayString=self.dateCell.detailTextLabel.text;
    }
    self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate:[NSDate date]];
}
/*!設定currentCurrency還有頁面相關顯示
 */
-(void)setAllCurrencyWithCurrency:(Currency *)currency{
    self.currentCurrency=currency;
    self.currency.detailTextLabel.text=currency.standardSign;
    self.currencySign.text=currency.sign;
}
-(void)saveImage:(UIImage *)image{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
//    NSData * binaryImageData = UIImagePNGRepresentation(image);
    NSData * binaryImageData = UIImageJPEGRepresentation(image, 1);
    //TODO: Trip加了index以後，用tripIndex當資料夾名字
    NSString *folderPath=[NSString stringWithFormat:@"%@/Potos/%@ %@",basePath,@"Trip ",self.currentTrip.name ];
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        NSLog(@"folder path exists.");
    }else{
        NSLog(@"creating folder...");
        NSError *error=nil;
        //建立資料夾
        [[NSFileManager defaultManager]createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"fail to create folder, error: %@", [error localizedDescription]);
        }
    }
    NSString *imagePath=[NSString stringWithFormat:@"%@/%lli.jpg",folderPath,[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
    //儲存檔案
    bool saveSuccess=[binaryImageData writeToFile:imagePath atomically:YES];
    if (saveSuccess) {
        NSLog(@"save photo to file:%@",imagePath);
    }else{
        NSLog(@"failed to save photo:%@",imagePath);
    }
}
#pragma mark - 事件
-(IBAction)save:(id)sender{
    Receipt *receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    Day *selectedDay=[self getTripDayByDate:self.selectedDayString];
    receipt.desc = self.desc.text;
    receipt.total=[NSNumber numberWithDouble:[self.totalPrice.text doubleValue]];
    receipt.time=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
    receipt.day=selectedDay;
    
    receipt.dayCurrency=[self getDayCurrencyWithTripDay:selectedDay Currency:self.currentCurrency];
    
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Receipt in AddReceiptTVC");
    //儲存照片
    for (UIImage *image in self.images) {
        [self saveImage:image];
    }
    
    [self.delegate theSaveButtonOnTheAddReceiptWasTapped:self];
    
}


- (void)pickerChanged:(UIDatePicker *)sender {
    if (sender==self.timePicker) {
        self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate: sender.date];
    }
    
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
    //2. 計算這次imageView大小位置，並把照片放進去
    NSInteger imgCount=[self.images count];
    double imgViewWidth=155;
    CGRect newImageRect=CGRectMake((imgViewWidth+5)*imgCount+5, 10, imgViewWidth, image.size.height/image.size.width*imgViewWidth);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:newImageRect];
    imgView.image=image;
    NSLog(@"loaded a image @%@",self.class);
    //3. 把imageView放進scrollView裡，並拉長scrollView
    [self.scrollView addSubview:imgView];
    CGSize scrollSize=CGSizeMake((imgViewWidth+5)*(imgCount+1), self.scrollView.frame.size.height);
    self.scrollView.contentSize=scrollSize; //要把scrollView拉大，才能scroll
    
    [self.images addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - lazy instantiation

-(UIDatePicker *) timePicker
{
    if (!_timePicker) {
        _timePicker = [[UIDatePicker alloc] init];
        _timePicker.datePickerMode=UIDatePickerModeTime;
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
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self.currentTrip];
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
    day.inTrip=self.currentTrip;
    
    NSLog(@"Create new Day in AddReceiptTVC");
    
    [self.managedObjectContext save:nil];  // write to database
    return day;
}
-(DayCurrency *)getDayCurrencyWithTripDay:(Day *)tripDay Currency:(Currency *)currency{
    //    //-----Date Formatter----------
    //    NSDateFormatter *dateFormatter;
    //    dateFormatter=[[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat=@"yyyy/MM/dd";
    
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
    NSLog(@"Creating DayCurrency...");
    
    DayCurrency *dayCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"DayCurrency"
                                                             inManagedObjectContext:self.managedObjectContext];
    dayCurrency.tripDay=tripDay;
    dayCurrency.currency=currency;
    
    NSLog(@"Create new DayCurrency:%@ @%@",currency.standardSign,self.class);
    
    [self.managedObjectContext save:nil];  // write to database
    return dayCurrency;
}
#pragma mark - 每次點選row的時候會做的事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //每次點選row時清除所有的picker
    [self dismissPicker];
    //點選row時關閉鍵盤
    [self dismissKeyboard:self.view];
    
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    if (clickCell==self.timeCell) {
        //TODO:不知道為什麼要用row判斷，不用row會錯
        BOOL hasBeTapped=indexPath.row==self.actingDateCellIndexPath.row;
        
        if (hasBeTapped) {
            //如果剛剛才按過，表示要關上Picker（不需要原本的actionDateCell了）
            self.actingDateCellIndexPath=nil;
        }else{
            
            self.actingDateCellIndexPath = indexPath;
            [self setPickerFrame:self.timePicker  WithIndexPath:indexPath];
            [self.view addSubview:self.timePicker ];
            [self animateToPlaceWithItemSize:[self.timePicker  sizeThatFits:CGSizeZero]];
            [self.timePicker  addTarget:self
                                 action:@selector(pickerChanged:)
                       forControlEvents:UIControlEventValueChanged];
        }
    }else{
        self.actingDateCellIndexPath=nil;
    }
    
}
/*! 遞迴尋找底下所有的Textfeild，當UITextField不是游標焦點時關閉keyboard
 */
-(void)dismissKeyboard:(UIView *) tagView{
    NSArray *subviews = [tagView subviews];
    for (UIView *subview in subviews) {
        [self dismissKeyboard:subview];
        //找是不是TextField
        if ([subview isKindOfClass:[UITextField class]]) {
            //當UITextField不是游標焦點時，就關閉鍵盤
            [subview resignFirstResponder];
        }
    }
}

//清除所有的picker
-(void)dismissPicker{
    for (UIView *subview in [self.view subviews]) {
        if ([subview isKindOfClass:[UIDatePicker class]]) {
            [subview removeFromSuperview];
            self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height-[self.timePicker sizeThatFits:CGSizeZero].height);
        }
    }
}

//開始編輯textField時做的事
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //清除所有的picker
    [self dismissPicker];
}

-(void)setPickerFrame:(UIDatePicker *)picker WithIndexPath:(NSIndexPath *)indexPath{
    //find the current table view size
    CGRect screenRect = [self.view bounds];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    //find the date picker size
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    
    //set the picker frame
    NSLog(@"screenRect.y=%f,lastcell.y=%f",screenRect.origin.y,cellRect.origin.y);
    CGRect pickerRect = CGRectMake(0.0,
                                   cellRect.origin.y+cellRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    picker.frame = pickerRect;
}

/*!動畫設定，讓某大小之物件，動作流暢呈現至畫面最底
 */
-(void)animateToPlaceWithItemSize:(CGSize)itemSize{
    //下面這是動畫設定，讓動作流暢到位：[UIView animateWithDuration: animations: completion: ];
    [UIView animateWithDuration: 0.4f
                     animations:^{
                         //animations裡面是終點位置
                         self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+itemSize.height);
                         if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
                             self.tableView.contentOffset=CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished) {} ];
}




#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //每次Segue時清除所有的picker
    [self dismissPicker];
    //點選Segue時關閉鍵盤
    [self dismissKeyboard:self.view];
    
    if ([segue.identifier isEqualToString:@"Trip Day Segue"]) {
        
        NSLog(@"Setting AddReceiptTVC as a delegate of TripDaysTVC...");
        
        TripDaysTVC *TripDaysTVC=segue.destinationViewController;
        TripDaysTVC.delegate=self;
        
        TripDaysTVC.managedObjectContext=self.managedObjectContext;
        
        //可以直接用indexPath找到CoreData裡的實際物件，然後pass給Detail頁
        TripDaysTVC.currentTrip=self.currentTrip;
        TripDaysTVC.selectedDayString=self.selectedDayString;
    }else if([segue.identifier isEqualToString:@"Currency Segue"]){
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



@end
