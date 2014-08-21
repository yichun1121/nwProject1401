//
//  AddCategoryTVC.m
//  TryTravel2gether
//
//  Created by YICHUN on 2014/4/6.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddCategoryTVC.h"

@interface AddCategoryTVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSString *selectedImageName;
//@property CGFloat *hue;
@property float hueFloat;
@property float saturationFloat;
@property float brightnessFloat;
@property float alphaFloat;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;

@end

@implementation AddCategoryTVC
@synthesize managedObjectContext,selectedCategory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.delegate=self;
    [self loadIconsInScrollView];
    
    
    UIColor *defaultSkyBlueColor=[UIColor colorWithRed:171/255.0 green:226/255.0 blue:245/255.0 alpha:1];
    
    //取得預設顏色的值---------------------
    CGFloat cgFloatHue=(CGFloat)self.hueFloat;
    CGFloat cgFloatSaturation=(CGFloat)self.saturationFloat;
    CGFloat cgFloatBrightness=(CGFloat)self.brightnessFloat;
    CGFloat cgFloatAlpha=(CGFloat)self.alphaFloat;
    [defaultSkyBlueColor getHue:&cgFloatHue saturation:&cgFloatSaturation brightness:&cgFloatBrightness alpha:&cgFloatAlpha];
//    self.hueFloat=cgFloatHue; //取得預設的天藍色色相
    self.hueFloat=drand48();    //以預設天藍色為基礎，random一個色相出來
    self.saturationFloat=cgFloatSaturation;
    self.brightnessFloat=cgFloatBrightness;
    self.alphaFloat=cgFloatAlpha;
    
    //設定slider對應的色相
    self.colorSlider.value=self.hueFloat;
    //顯示random後的顏色
    self.iconImage.layer.borderWidth=0;
    [self.iconImage.layer setMasksToBounds:YES];
    [self.iconImage.layer setCornerRadius:4.0];
    UIColor *randomColor=[UIColor colorWithHue:self.hueFloat saturation:self.saturationFloat brightness:self.brightnessFloat alpha:self.alphaFloat];
    self.iconImage.backgroundColor=randomColor;
    self.iconImage.layer.borderColor=[randomColor CGColor];
    
    //設定預設圖示名稱
    self.selectedImageName=@"empty";
}
- (IBAction)sliderTouchUp:(UISlider *)sender {
    NSLog(@"Slider Touched Up");
    //下面這是動畫設定，讓動作流暢到位：[UIView animateWithDuration: animations: completion: ];
    [UIView animateWithDuration: 0.4f
                     animations:^{
                         //animations裡面是終點位置
                         self.hueFloat=self.colorSlider.value;
                         UIColor *newColor=[UIColor colorWithHue:self.hueFloat saturation:self.saturationFloat brightness:self.brightnessFloat alpha:self.alphaFloat];
                         self.iconImage.backgroundColor=newColor;
                     }
                     completion:^(BOOL finished) {} ];

}
- (IBAction)sliderValueChanged:(id)sender {
    NSLog(@"Slider Value Chaged");
    self.hueFloat=self.colorSlider.value;
    UIColor *newColor=[UIColor colorWithHue:self.hueFloat saturation:self.saturationFloat brightness:self.brightnessFloat alpha:self.alphaFloat];
    self.iconImage.backgroundColor=newColor;
}
#pragma mark - 事件
-(IBAction)save:(id)sender{
    Itemcategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"Itemcategory"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    category.name = self.name.text;
    category.iconName=self.selectedImageName;
    UIColor *hsbColor= [UIColor colorWithHue:self.hueFloat saturation:self.saturationFloat brightness:self.brightnessFloat alpha:self.alphaFloat];
    CGFloat cgFloatRed;
    CGFloat cgFloatGreen;
    CGFloat cgFloatBlue;
    CGFloat cgFloatAlpha;
    [hsbColor getRed:&cgFloatRed green:&cgFloatGreen blue:&cgFloatBlue alpha:&cgFloatAlpha];
    NSString *rgbString=[NSString stringWithFormat:@"%000.0f%000.0f%000.0f",cgFloatRed*255,cgFloatGreen*255,cgFloatBlue*255];
    category.colorRGB=rgbString;
    
    [self.managedObjectContext save:nil];  // write to database
    NSLog(@"Save new Receipt in AddReceiptTVC");
    [self.delegate theSaveButtonOnTheAddCategoryWasTapped:self];
}
-(void)loadIconsInScrollView{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UserIcons"
                                                     ofType:@"plist"];
    NSDictionary *imageNames = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    int loadedImageCount=0;
    float iconWidth=30;
    float superPadding=20;
    float iconborder=5;
    int maxColumn=(self.scrollView.frame.size.width-superPadding*2)/(iconWidth+iconborder);
    int rowNum=0;
    int colNum=0;
    for (NSString *imageName in imageNames) {
        //如果本行已滿，則需換下一行，且從第一欄排起
        if (loadedImageCount%maxColumn==0&&loadedImageCount!=0) {
            rowNum++;
            //如果原本的scrollView的高度不夠，要+一個icon高＋一個iconBorder高
            if (rowNum*(iconWidth+iconborder*2+superPadding*2)-self.scrollView.frame.size.height>superPadding) {
                CGSize newScrollViewSize=CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+iconWidth+iconborder);
                self.scrollView.contentSize=newScrollViewSize;
            }
            colNum=0;
        }
        //icon圖片設定-------------------------------------------------------------------------------
        UIImage *image=[UIImage imageNamed:imageName];
        UIImageView *iconView=[[UIImageView alloc]initWithImage:image];
        CGRect imageRect=CGRectMake(superPadding+colNum*(iconWidth+iconborder),superPadding+rowNum*(iconWidth+iconborder*2),iconWidth,iconWidth);
        iconView.frame=imageRect;
        iconView.restorationIdentifier=[NSString stringWithFormat:@"userIcon_%@", imageName];   //不得已把icon的名字放在imageView的id
        iconView.userInteractionEnabled=YES;    //Default是NO，要加這個事件才有用
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [singleTap setNumberOfTapsRequired:1];
        [iconView addGestureRecognizer:singleTap];
        [self.scrollView addSubview:iconView];
        
        colNum++;
        loadedImageCount++;
    }
}
-(void)iconClick:(id)sender{
    if ([sender isKindOfClass:UITapGestureRecognizer.class]) {
        UITapGestureRecognizer *clickGesture=(UITapGestureRecognizer *)sender;
        if ([clickGesture.view isKindOfClass:UIImageView.class]) {
            UIImageView *clickedIcon=(UIImageView *)clickGesture.view;
            self.iconImage.image=clickedIcon.image;
            self.selectedImageName=[clickedIcon.restorationIdentifier componentsSeparatedByString:@"_"][1];
        }
    }
}
#pragma mark - delegation
#pragma mark 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
