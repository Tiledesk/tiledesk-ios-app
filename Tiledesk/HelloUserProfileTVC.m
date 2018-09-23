//
//  HelloUserProfileTVC.m
//  chat21
//
//  Created by Andrea Sponziello on 18/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloUserProfileTVC.h"
#import "HelloUser.h"
#import "ChatUser.h"
#import <DBChooser/DBChooser.h>
#import "ChatMessagesVC.h"
#import "ChatUIManager.h"
#import "ChatManager.h"
#import "ChatDiskImageCache.h"
#import "ChatImagePreviewVC.h"
#import "ChatUtil.h"

@interface HelloUserProfileTVC ()

@end

@implementation HelloUserProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfilePhoto:)];
    singleTap.numberOfTapsRequired = 1;
    [self.profilePhotoImageView setUserInteractionEnabled:YES];
    [self.profilePhotoImageView addGestureRecognizer:singleTap];
    
    [self setupProfileImage:self.user.userid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.usernameLabel.text = self.user.username;
    self.useridLabel.text = self.user.userid;
    self.emailLabel.text = self.user.email;
    self.fullNameLabel.text = self.user.displayName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell will be deselected by following line.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        NSLog(@"Chat with %@", self.user.userid);
        [self sendMessage];
    }
}

-(void)sendMessage {
    
    UIViewController *backVC = [self backViewController];
    
    NSLog(@">>>>>> Back VC Class: %@", NSStringFromClass(backVC.class));
    if([backVC isKindOfClass:[ChatMessagesVC class]]) {
        NSLog(@"IS MESSAGES!!!!");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        NSLog(@"NOT MESSAGES");
    }
    
    ChatUser *chatUser = [[ChatUser alloc] init];
    chatUser.userId = self.user.userid;
    chatUser.firstname = self.user.firstName;
    chatUser.lastname = self.user.lastName;
    chatUser.fullname = self.user.fullName;
    
    [ChatUIManager moveToConversationViewWithUser:chatUser];
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

// **************************************************
// ************** PROFILE PHOTO SECTION *************
// **************************************************

-(void)setupProfileImage:(NSString *)profileId {
    self.imageCache = [ChatManager getInstance].imageCache;
    
    // setup circle image view
    self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.width / 2;
    self.profilePhotoImageView.clipsToBounds = YES;
    
    // try to get image from cache
    NSString *imageURL = [ChatManager profileImageURLOf:profileId];
    NSURL *url = [NSURL URLWithString:imageURL];
    NSString *cache_key = [self.imageCache urlAsKey:url];
    UIImage *cachedProfileImage = [self.imageCache getCachedImage:cache_key];
    [self setupCurrentProfileViewWithImage:cachedProfileImage];
    [self.imageCache getImage:imageURL completionHandler:^(NSString *imageURL, UIImage *image) {
        [self setupCurrentProfileViewWithImage:image];
    }];
}

-(void)setupCurrentProfileViewWithImage:(UIImage *)image {
    self.currentProfilePhoto = image;
    if (image == nil) {
        [self resetProfilePhoto];
    }
    else {
        self.profilePhotoImageView.image = image;
    }
}

-(void)resetProfilePhoto {
    self.profilePhotoImageView.image = [UIImage imageNamed:@"user-profile-man.jpg"];
}

-(void)tapProfilePhoto:(UITapGestureRecognizer *)gestureRecognizer {
    [self showPhoto];
}

-(void)showPhoto {
    if (self.currentProfilePhoto) {
        [self performSegueWithIdentifier:@"imagePreview" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"imagePreview"]) {
        ChatImagePreviewVC *vc = (ChatImagePreviewVC *)[segue destinationViewController];
        vc.image = self.currentProfilePhoto;
    }
}

// **************************************************
// ************ END PROFILE PHOTO SECTION ***********
// **************************************************

@end
