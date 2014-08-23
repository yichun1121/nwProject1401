//
//  NWGoogleDriveUtiles.h
//  TryTravel2gether
//
//  Created by vincent on 2014/8/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"

@class NWGoogleDriveBackupdataTVC;
@protocol NWGoogleDriveBackupdataTVCDelegate <NSObject>


@end
@interface NWGoogleDriveBackupdataTVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightNavButton;

@property (nonatomic, retain) GTLServiceDrive *driveService;

@end
