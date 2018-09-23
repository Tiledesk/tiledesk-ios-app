//
//  HelloUserProfileTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 18/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloUser;
@class ChatDiskImageCache;

@interface HelloUserProfileTVC : UITableViewController

@property (strong, nonatomic) HelloUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *useridLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (assign, nonatomic) UIImage *currentProfilePhoto;
@property (strong, nonatomic) ChatDiskImageCache *imageCache;

@end
