//
//  NWGoogleDriveUtiles.m
//  TryTravel2gether
//
//  Created by vincent on 2014/8/18.
//  Copyright (c) 2014年 NW. All rights reserved.
//

#import "NWGoogleDriveBackupdataTVC.h"
static NSString *const kKeychainItemName = @"Google Drive Quickstart Travel2gether";
static NSString *const kClientID = @"566516813634-58rrv6hegr5bh8k2l7l43q1rs08o49k0.apps.googleusercontent.com";
static NSString *const kClientSecret = @"eLZXM2B0_IelouGLmT2baHUx";

@implementation NWGoogleDriveBackupdataTVC

@synthesize driveService;
@synthesize rightNavButton=_rightNavButton;

- (UIBarButtonItem *)rightNavButton {
    if (!_rightNavButton) {
        
        _rightNavButton = [[UIBarButtonItem alloc]
                           initWithTitle:@"Logout"
                           style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(doLogout)
                           ];
        
      
    }
    return _rightNavButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                                         clientID:kClientID
                                                                                     clientSecret:kClientSecret];
    
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
//    if (![self isAuthorized])
//    {
//        [NSThread sleepForTimeInterval:1];
//    }
      [self googleGTLServiceDriveLogin];
  
}

- (void)googleGTLServiceDriveLogin
{

    
    if (![self isAuthorized])
    {
        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [[self navigationController] pushViewController:[self createAuthController] animated:YES];
        [self showLogoutBut:NO];
    }else{
        [self showLogoutBut:YES] ;
    }
}
//暫時無用
//// Handle selection of an image
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    [self dismissModalViewControllerAnimated:YES];
//    [self uploadPhoto:image];
//}
//
//// Handle cancel from image picker/camera.
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissModalViewControllerAnimated:YES];
//}

#pragma mark - ➤ 認證登入google

- (NSString *)signedInUsername {
    // Get the email address of the signed-in user.
    GTMOAuth2Authentication *auth = self.driveService.authorizer;
    BOOL isSignedIn = auth.canAuthorize;
    if (isSignedIn) {
        return auth.userEmail;
    } else {
        return nil;
    }
}

- (BOOL)isAuthorized
{
    NSString *name = [self signedInUsername];
    return (name != nil);
}

// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    //建立google 登入畫面
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
        
    }
    else
    {
        self.driveService.authorizer = authResult;
        
    }
}

//在navigation bat 上加 button
-(void)showLogoutBut:(BOOL)isHide
{
    if (isHide) {
        self.navigationItem.rightBarButtonItem=self.rightNavButton;
    }else{
        self.navigationController.navigationItem.rightBarButtonItem=nil;
    }
}

-(void)doLogout
{
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName ];
    self.driveService.authorizer = nil;
    [[self navigationController] pushViewController:[self createAuthController] animated:YES];
}

#pragma mark - ➤ 上傳圖片至google Drive
// Uploads a photo to Google Drive
- (void)uploadPhoto:(UIImage*)image
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
    
    GTLDriveFile *file = [GTLDriveFile object];
    file.title = [dateFormat stringFromDate:[NSDate date]];
    file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
    file.mimeType = @"image/png";
    
    NSData *data = UIImagePNGRepresentation((UIImage *)image);
    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
                                                       uploadParameters:uploadParameters];
    
    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
    
    [self.driveService executeQuery:query
                  completionHandler:^(GTLServiceTicket *ticket,
                                      GTLDriveFile *insertedFile, NSError *error) {
                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
                      if (error == nil)
                      {
                          NSLog(@"File ID: %@", insertedFile.identifier);
                          [self showAlert:@"Google Drive" message:@"File saved!"];
                      }
                      else
                      {
                          NSLog(@"An error occurred: %@", error);
                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
                      }
                  }];
}

// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

#pragma mark - ➤ alert 訊息的通用method
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}

@end
