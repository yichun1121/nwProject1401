//
//  AddGroupTVC.m
//  TryTravel2gether
//
//  Created by apple on 2014/4/26.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "AddGroupTVC.h"
#import "Group.h"
#import "GuyInTrip.h"

@interface AddGroupTVC ()
@property (strong,nonatomic) NSMutableSet *selectedGuys;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@end

@implementation AddGroupTVC
@synthesize selectedGuys=_selectedGuys;

-(NSMutableSet *) selectedGuys
{
    if (!_selectedGuys) {
        _selectedGuys = [[NSMutableSet alloc] init];
    }
    return _selectedGuys;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.groupName.delegate=self; //要加delegate=self，監聽textfield，才能在return時收鍵盤（textFieldShouldReturn）
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)save:(UIBarButtonItem *)sender {
    
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                             inManagedObjectContext:self.managedObjectContext];
    
    group.name = self.groupName.text;
    group.inTrip=self.currentTrip;
    [self.managedObjectContext save:nil];  // write to database
    [self setGroup:group forGuys:self.selectedGuys RealInTrip:self.currentTrip];
    [self setGroup:group forGuys:self.selectedGuys NotRealInTrip:self.currentTrip];
    [self.delegate theSaveButtonOnTheAddGroupWasTapped:self];
}

#pragma mark - GuyInTrip
//原本已經在的人就直接新增Group
-(void)setGroup:(Group *)group forGuys:(NSSet *)selectedGuys RealInTrip:(Trip *)trip {
    
    for (Guy *guy in selectedGuys) {

    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"GuyInTrip" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(inTrip=%@)AND (guy=%@)",trip,guy];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if ([objects count]>0) {
            for (int i=0; i<[objects count]; i++) {
                GuyInTrip *guyInTrip=objects[i];
                [guyInTrip addGroupsObject:group];
                [self.managedObjectContext save:nil];
            }
        }
    }
  
}
//不在trip的人新增GuyInTrip & 以個人為單位的group
-(void)setGroup:(Group *)group forGuys:(NSSet *)selectedGuys NotRealInTrip:(Trip *)trip{
    NSMutableArray *guyInTripArray=[NSMutableArray new];
    for (GuyInTrip * guyInTrip in trip.guysInTrip) {
        [guyInTripArray addObject:guyInTrip.guy];
    }

    for (Guy *guy in selectedGuys) {
        if (![guyInTripArray containsObject:guy]) {
           
            Group *groupForEachGuy = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                                                   inManagedObjectContext:self.managedObjectContext];
            groupForEachGuy.name=guy.name;
            groupForEachGuy.inTrip=trip;
            [self.managedObjectContext save:nil];
            
            
            GuyInTrip *guyInTrip = [NSEntityDescription insertNewObjectForEntityForName:@"GuyInTrip"
                                                                 inManagedObjectContext:self.managedObjectContext];
            guyInTrip.realInTrip=[NSNumber numberWithBool:NO];
            guyInTrip.inTrip=trip;
            guyInTrip.groups=[NSSet setWithObjects:group,groupForEachGuy,nil];
            guyInTrip.guy=guy;
            
            [self.managedObjectContext save:nil];
            
            
            
        }
    }

}

#pragma mark - ➤ Navigation：Segue Settings
// 內建，準備Segue的method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //判斷是哪條連線（會對應Segue的名稱）
	if ([segue.identifier isEqualToString:@"Select Guy Segue From AddGroupTVC"])
	{
        NSLog(@"Setting AddGroupTVC as a delegate of SelectGuysCDTVC");
        
        SelectGuysCDTVC *selectGuysCDTVC = segue.destinationViewController;
        selectGuysCDTVC.delegate = self;
        /*
         已經在SelectGuysCDTVC裡宣告了一個delegate（是SelectGuysCDTVCDelegate）
         selectGuysCDTVC.delegate=self的意思是：我要監控SelectGuysCDTVC
         */
        
        selectGuysCDTVC.managedObjectContext=self.managedObjectContext;
        //把這個managedObjectContext傳過去，使用同一個managedObjectContext。（這樣新增東西才有反應吧？！）
	}else {
        NSLog(@"Unidentified Segue Attempted! @%@",self.class);
    }
}

#pragma mark - delegation
#pragma mark - 監測UITextFeild事件，按下return的時候會收鍵盤
//要在viewDidLoad裡加上textField的delegate=self，才監聽的到
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)guyWasSelectedInSelectGuysCDTVC:(SelectGuysCDTVC *)controller{
    self.selectedGuys=controller.selectedGuys;
    [controller.navigationController popViewControllerAnimated:YES];
}



@end
