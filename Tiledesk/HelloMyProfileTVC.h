//
//  HelloMyProfileTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 19/07/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatDiskImageCache;

@interface HelloMyProfileTVC : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
- (IBAction)helpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;

// profile photo
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (assign, nonatomic) UIImage *currentProfilePhoto;
@property (assign, nonatomic) NSString *profileId;

// imagepicker
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIImagePickerController *photoLibraryController;
@property (nonatomic, strong) UIImage *scaledImage;
@property (strong, nonatomic) UIImage *bigImage;
@property (strong, nonatomic) ChatDiskImageCache *imageCache;

+(void)showLoginModalOnFirstTab;

@end

