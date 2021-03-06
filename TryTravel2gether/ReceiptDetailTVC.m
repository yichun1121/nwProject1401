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
#import "NWKeyboardUtils.h"
#import "NWPickerUtils.h"
#import "NWUIScrollViewMovePostition.h"
#import "Account.h"
#import "Trip+Days.h"

@interface ReceiptDetailTVC ()

@property (nonatomic)  NSDateFormatter *dateFormatter;
@property (nonatomic)  NSDateFormatter *timeFormatter;
@property (nonatomic)  NSDateFormatter *dateTimeFormatter;
@property Currency *currentCurrency;
@property (weak, nonatomic) IBOutlet UITableViewCell *currency;
@property (weak, nonatomic) IBOutlet UITableViewCell *paymentAccount;
@property (weak, nonatomic) IBOutlet UILabel *currencySign;

//@property (weak, nonatomic) IBOutlet UITextField *totalPrice;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property NSIndexPath * actingCellIndexPath;
@property (strong,nonatomic) UIDatePicker *timePicker;
@property (nonatomic)  UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/*!舊照片+新增照片的uiimage
 */
@property (nonatomic) NSMutableArray *images;
/*!
 記錄已存的照片資訊（檔名路徑）*/
@property (nonatomic) NSMutableArray *imageRelativePath;
@property (weak, nonatomic) IBOutlet UIButton *totalPrice;
@property (strong,nonatomic)Calculator *calculator;
@property BOOL isCalculatorOpened;
@property (strong,nonatomic) Account *selectedAccount;
@end

@implementation ReceiptDetailTVC
@synthesize timePicker=_timePicker;
@synthesize imagePicker=_imagePicker;
@synthesize images=_images;
@synthesize calculator=_calculator;
@synthesize result=_result;
@synthesize totalPrice;
@synthesize arrayOfStack=_arrayOfStack;
@synthesize selectedAccount=_selectedAccount;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //-----Date Formatter----------
    
    //設定UITextFeild的delegate
    self.desc.delegate=self;
    //設定頁面初始的顯示狀態
    //-----顯示day資訊-----------
    [self configureTheCell];
    //----Account不存在時
    if(!self.selectedAccount){
        self.paymentAccount.detailTextLabel.text=NSLocalizedString(@"Unspecified_Account", @"CellDesc");
    }
}



/*!show計算機
 */
-(void)showCalculator{
    
    [self presentViewController:self.calculator animated:YES completion:nil];
}
- (IBAction)click:(UIButton *)sender {
    self.calculator.arrayOfStack=[self.arrayOfStack mutableCopy];
    [self showCalculator];
    self.isCalculatorOpened=YES;
    
}

-(Photo *)saveImage:(UIImage *)image{
    //    NSData * binaryImageData = UIImagePNGRepresentation(image);
    NSData * binaryImageData = UIImageJPEGRepresentation(image, 0.5);     //數字是壓縮比<=1
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //TODO: Trip加了index以後，用tripIndex當資料夾名字
    NSString * relativeFolder=[Photo newRelativeFolderWithTripIndex:self.receipt.day.inTrip.tripIndex];

    NSString *folderPath=[NSString stringWithFormat:@"%@%@",basePath,relativeFolder];
    //-----檢查預存放的資料夾路徑-------------------------
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
    NSString *fileName=[NSString stringWithFormat:@"%lli.jpg",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@",folderPath,fileName];
    //-----儲存檔案-------------------------------------
    bool saveSuccess=[binaryImageData writeToFile:imagePath atomically:YES];
    if (saveSuccess) {
        NSLog(@"save photo to file:%@",imagePath);
    }else{
        NSLog(@"failed to save photo:%@",imagePath);
    }
    //-----儲存entity:Photo-------------------------------------
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                 inManagedObjectContext:self.managedObjectContext];
    
    photo.relativePath=[NSString stringWithFormat:@"%@/%@",relativeFolder,fileName];
    photo.fileName=fileName;
    [self.managedObjectContext save:nil];  // write to database
    return photo;
}
#pragma mark - 事件
-(void)save:(id)sender{
    Day *selectedDay=[self.receipt.day.inTrip getTripDayByDateString:self.selectedDayString];
    self.receipt.desc = self.desc.text;
    self.receipt.total=[NSNumber numberWithDouble:[self.totalPrice.currentTitle doubleValue]];
    self.receipt.time=[self.timeFormatter dateFromString:self.timeCell.detailTextLabel.text];
    self.receipt.day=selectedDay;
    
    self.receipt.dayCurrency=[self getDayCurrencyWithTripDay:selectedDay Currency:self.currentCurrency];
    
    self.receipt.account=self.selectedAccount;
    
    //CoreData Transformable type
    NSData *receiptArrayData=[NSKeyedArchiver archivedDataWithRootObject:self.arrayOfStack];
    self.receipt.calculatorArray=receiptArrayData;
    
    NSMutableSet *mtbImages=[[NSMutableSet alloc]init];
    //移除不需要的照片---------------------------------------------------------------------
    //如果mtbImages裡的路徑不包含于現有的self.imageRelativePath，代表這張照片不需要了，所以可以移掉
    NSFileManager *fileManager=[NSFileManager defaultManager];
    for (Photo * photo in self.receipt.photos) {
        if ([self.imageRelativePath containsObject: photo.relativePath]) {
            [mtbImages addObject:photo];
            
        }else{
            NSError *error;
            BOOL success = [fileManager removeItemAtPath:photo.relativePath error:&error];
            if (success) {
                NSLog(@"deletePhotoFile@%@: %@",self.class,photo.relativePath);
                NSLog(@"Deleting Photo object...");
                [self.managedObjectContext deleteObject:photo];
            }else{
                NSLog(@"Fail! deletePhotoFile: %@ @%@ (%@)",photo.relativePath,self.class,error.localizedDescription);
            }
        }
        
    }
    //儲存新加入的照片---------------------------------------------------------------------
    //self.imageRelativePath和self.images的資料差異就是新增的照片，把存在images但不在imagePath裡的照片存起來
    int countExistingPhoto=(int)self.imageRelativePath.count;
    for (int i=countExistingPhoto; i<self.images.count; i++) {
        UIImage *image=self.images[i];
        Photo *photo=[self saveImage:image];
        [mtbImages addObject:photo];
    }
    self.receipt.photos=mtbImages;
    
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
    //3. 加入MutableArray
    [self.images addObject:image];
    //4. 存入Album
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*! 載入ImageView，配合已存在的照片放置新位置並延伸scrollView為適當寬度
 */
-(void)loadImageIntoScrollView:(UIImage *)image{
    //1. 計算這次imageView大小位置，並把照片放進去----------------------------------------------------------
    NSInteger imgCount=[self.images count];
    double imgViewWidth=155;
    CGRect newImageRect=CGRectMake((imgViewWidth+5)*imgCount+5, 10, imgViewWidth, image.size.height/image.size.width*imgViewWidth);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:newImageRect];
    imgView.image=image;
    NSLog(@"loaded a image @%@",self.class);
    //2. 加刪除按鈕------------------------------------------------------------------------------------
    float btnDiameter=30;   //按鈕直徑
    float padding=5;
    CGRect btnDeleteReck=CGRectMake(imgViewWidth-padding-btnDiameter, padding, btnDiameter, btnDiameter);
    UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnDelete setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    btnDelete.backgroundColor=[UIColor whiteColor];
    [btnDelete.titleLabel setTextColor:[UIColor blackColor]];
    btnDelete.alpha=0.7;
    CALayer *layer =btnDelete.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:btnDiameter/2];
    [btnDelete addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchDown];
    btnDelete.frame=btnDeleteReck;
    //[btnDelete setTitle:@"X" forState:UIControlStateNormal];
    [imgView addSubview:btnDelete];
    imgView.userInteractionEnabled=YES; //預設是NO，設成YES後subview的button event才有效
    //3. 把imageView放進scrollView裡，並拉長scrollView---------------------------------------------------
    [self.scrollView addSubview:imgView];
    CGSize scrollSize=CGSizeMake((imgViewWidth+5)*(imgCount+1), self.scrollView.frame.size.height);
    self.scrollView.contentSize=scrollSize; //要把scrollView拉大，才能scroll
    
}
-(void)deleteImageClick:(id)sender{
    if ([sender isKindOfClass:UIButton.class]) {
        UIButton *btnDelete=(UIButton *)sender;
        if ([btnDelete.superview isKindOfClass:UIImageView.class]) {
            //清空原本scrollView裡面的照片
            for (UIView *view in self.scrollView.subviews) {
                [view removeFromSuperview];
            }
            CGSize scrollSize=CGSizeMake(0, self.scrollView.frame.size.height);
            self.scrollView.contentSize=scrollSize;
            NSMutableArray *tempImages=[self.images mutableCopy];
            NSMutableArray *tempImagePath=[self.imageRelativePath mutableCopy];
            [self.images removeAllObjects];
            [self.imageRelativePath removeAllObjects];
            //重load
            UIImageView *imgView=(UIImageView *)btnDelete.superview;
            for (int i=0; i<[tempImages count]; i++) {
                if (imgView.image==tempImages[i]) {
                    [tempImages removeObjectAtIndex:i];
                    if ([tempImagePath count]>i) {
                        //如果是原有儲存過的照片就會有path，沒有的話就不用刪
                        [tempImagePath removeObjectAtIndex:i];
                    }
                    i=i-1;  //原本的i被刪掉，後面的會往前遞補，所以下個run i++後要從同一個i開始跑，現在先減掉
                }else{
                    [self loadImageIntoScrollView:tempImages[i]];   //要先load再add，不然位置會計算錯
                    [self.images addObject:tempImages[i]];
                    if ([tempImagePath count] >i) {
                        [self.imageRelativePath addObject:tempImagePath[i]];
                    }
                }
                NSLog(@"image %i",i);
            }
        }
        NSLog(@"delete image");
    }
}
#pragma mark - lazy instantiation
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter=[[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat=@"yyyy/MM/dd";
    }
    return _dateFormatter;
}

-(NSDateFormatter *)timeFormatter{
    if (!_timeFormatter) {
        _timeFormatter=[[NSDateFormatter alloc]init];
        _timeFormatter.dateFormat=@"HH:mm";
    }
    return _timeFormatter;
}

-(NSDateFormatter *)dateTimeFormatter{
    if (!_dateTimeFormatter) {
        _dateTimeFormatter=[[NSDateFormatter alloc]init];
        _dateTimeFormatter.dateFormat=[NSString stringWithFormat:@"%@ %@",self.dateFormatter.dateFormat,self.timeFormatter.dateFormat];
    }
    return _dateTimeFormatter;
}
-(UIDatePicker *)timePicker{
    if(_timePicker == nil){
        _timePicker = [[UIDatePicker alloc] init];
        _timePicker.datePickerMode = UIDatePickerModeTime;
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
-(NSMutableArray *)imageRelativePath{
    if (!_imageRelativePath) {
        _imageRelativePath=[NSMutableArray new];
    }
    return _imageRelativePath;
}
-(Calculator *)calculator{
    if(_calculator==nil){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _calculator=[storyboard instantiateViewControllerWithIdentifier:@"calculator"];
        _calculator.delegate=self;
        [_calculator setModalPresentationStyle:UIModalPresentationFullScreen];
        
    }
    return _calculator;
}
-(NSMutableArray *)arrayOfStack{
    if(!_arrayOfStack){
        _arrayOfStack=[NSMutableArray new];
    }
    return _arrayOfStack;
}

#pragma mark - Table view data source
-(void)configureTheCell{
    [self setAllCurrencyWithCurrency:self.receipt.dayCurrency.currency];
    [self.totalPrice setTitle:[NSString stringWithFormat:@"%@", self.receipt.total] forState:UIControlStateNormal];
    self.desc.text=self.receipt.desc;
    self.dateCell.detailTextLabel.text=[self.dateFormatter stringFromDate:self.receipt.day.date];
    self.timeCell.detailTextLabel.text=[self.timeFormatter stringFromDate:self.receipt.time];
    self.selectedDayString=[self.dateFormatter stringFromDate: self.receipt.day.date];
    self.arrayOfStack=[NSKeyedUnarchiver unarchiveObjectWithData:self.receipt.calculatorArray];
    self.selectedAccount=self.receipt.account;
    self.paymentAccount.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.receipt.account.name];
    
    for (Photo * photo in self.receipt.photosOrdered) {
        UIImage *image=photo.image;
        [self loadImageIntoScrollView:image];   //要先load再add，不然位置會計算錯
        [self.images addObject:image];
        [self.imageRelativePath addObject:photo.relativePath];
    }
}

/*!設定currentCurrency還有頁面相關顯示
 */
-(void)setAllCurrencyWithCurrency:(Currency *)currency{
    self.currentCurrency=currency;
    self.currency.detailTextLabel.text=currency.standardSign;
    self.currencySign.text=currency.sign;
}
#pragma mark - ▣ CRUD_TripDay+DayCurrency
/*!以yyyy/MM/dd的日期字串取得本旅程中對應的Day，如果沒有這天，回傳nil
 */
//-(Day *)getTripDayByDate:(NSString *)dateString{
//    NSLog(@"Find the trip day:%@ in the current trip.",dateString);
//    NSEntityDescription *entityDesc =
//    [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
//    
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    
//    NSDate *date= [self.dateFormatter dateFromString:dateString];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(date = %@) AND (inTrip=%@)", date,self.receipt.day.inTrip];
//    [request setPredicate:pred];
//    
//    NSError *error;
//    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
//    
//    if ([objects count] == 0) {
//        return [self createDayInCurrentTripByDateString:date];
//    } else {
//        return objects[0];
//    }
//}
//-(Day *)createDayInCurrentTripByDateString:(NSDate *)date{
//    NSLog(@"Create the new day in the current trip.");
//    
//    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day"
//                                             inManagedObjectContext:self.managedObjectContext];
//    day.name=@"";
//    day.date=date;
//    day.inTrip=self.receipt.day.inTrip;
//    
//    NSLog(@"Create new Day in AddReceiptTVC");
//    
//    [self.managedObjectContext save:nil];  // write to database
//    return day;
//}
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
    //每次Segue時清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
    //點選Segue時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
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
        
    }else if([segue.identifier isEqualToString:@"Payment Segue From Receipt Detail"]){
        NSLog(@"Setting CurrencyCDTVC as a delegate of TripDaysTVC...");
        SelectPaymentCDTVC *selectPaymentCDTVC=segue.destinationViewController;
        
        selectPaymentCDTVC.delegate=self;
        selectPaymentCDTVC.managedObjectContext=self.managedObjectContext;
        selectPaymentCDTVC.selectedAccount=self.receipt.account;
        selectPaymentCDTVC.currentTrip=self.receipt.day.inTrip;
    }
}


#pragma mark 監測點選row時候的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *clickCell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    //每次點選row時清除所有的picker
    [NWPickerUtils dismissPicker:tableView];
    //點選row時關閉鍵盤
    [NWKeyboardUtils  dismissKeyboard4TextField:self.view];
    
    if (clickCell==self.timeCell) {
        bool hasBeTapped=NO;
        if(indexPath.row==self.actingCellIndexPath.row){
            hasBeTapped=YES;
        }
        if (hasBeTapped) {
            self.actingCellIndexPath=nil;
        }else{
            self.actingCellIndexPath=indexPath;
            
            [NWPickerUtils setPickerInTableView:self.timePicker tableView:tableView didSelectRowAtIndexPath:indexPath];
            
            [self.view addSubview:self.timePicker ];
            [NWUIScrollViewMovePostition autoContentOffsetToTableViewCenter:tableView didSelectRowAtIndexPath:indexPath withTagItemSize:[self.timePicker sizeThatFits:CGSizeZero]];
            [self.timePicker  addTarget:self
                                 action:@selector(pickerChanged:)
                       forControlEvents:UIControlEventValueChanged];
            
        }
        // 想要改變cell高度，需要重新整理tableView，beginUpdates和endUpdates
        //[self.tableView beginUpdates];
        //[self.tableView endUpdates];
    }else{
        self.actingCellIndexPath=nil;
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

//開始編輯textField時做的事
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //清除所有的picker
    [NWPickerUtils dismissPicker:self.tableView];
}
-(void)theCancelButtonOnCalcultorWasTapped:(Calculator *)controller{
    //TODO:controller和self怎麼沒差別
    [controller dismissViewControllerAnimated:YES completion:Nil];
    
}
-(void)theOkButtonOnCalcultorWasTapped:(Calculator *)controller{
    
    self.result=controller.result;
    self.arrayOfStack=[controller.arrayOfStack copy];
    [self.totalPrice setTitle:[NSString stringWithFormat:@"%@",self.result] forState:UIControlStateNormal];
    
    //TODO:controller和self怎麼沒差別
    [controller dismissViewControllerAnimated:YES completion:Nil];
    
}

-(void)theSaveButtonOnTheSelectPaymentWasTapped:(SelectPaymentCDTVC *)controller{
    if (!controller.selectedAccount.name) {
        self.paymentAccount.detailTextLabel.text=NSLocalizedString(@"Unspecified_Account", @"CellDesc");
        self.selectedAccount=nil;
    }else{
        self.paymentAccount.detailTextLabel.text=[NSString stringWithFormat:@"%@",controller.selectedAccount.name];
        self.selectedAccount=controller.selectedAccount;
    }
    [controller.navigationController popViewControllerAnimated:YES];
}
////下面這個目前沒有使用
//#pragma mark 負責長cell的高度，也在這設定actingPicker（每次會因為tableView beginUpdates和endUpdates重畫）
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height=self.tableView.rowHeight;
//    return height;
//}
@end
