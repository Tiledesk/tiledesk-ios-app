//
//  HelloAuthTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 17/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloChatUtil.h"
#import "ChatUser.h"
#import "HelloAppDelegate.h"
#import "HelloApplicationContext.h"
#import "HelloUser.h"
#import "ChatManager.h"
#import "ChatUIManager.h"
#import "ChatMessagesVC.h"
#import "HelloUserProfileTVC.h"
#import "ChatConversationsVC.h"

@import Firebase;

@implementation HelloChatUtil

+(void)initChat {
    HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
    ChatUser *chatUser = [[ChatUser alloc] init];
    chatUser.userId = app.applicationContext.loggedUser.userid;
    chatUser.firstname = app.applicationContext.loggedUser.firstName;
    chatUser.lastname = app.applicationContext.loggedUser.lastName;
    
    ChatManager *chatm = [ChatManager getInstance];
    [chatm startWithUser:chatUser];
    NSLog(@"Updates user from local contacts synch...");
    [chatm getContactLocalDB:chatUser.userId withCompletion:^(ChatUser *user) {
        NSLog(@"user found: %@, user_id: %@, user.firstname: %@", user, user.userId, user.firstname);
        if (user && user.userId && ![user.firstname isEqualToString:@""]) {
            chatUser.firstname = user.firstname;
            chatUser.lastname = user.lastname;
            app.applicationContext.loggedUser.firstName = user.firstname;
            app.applicationContext.loggedUser.lastName = user.lastname;
            [app.applicationContext signin:app.applicationContext.loggedUser];
        }
    }];
    // plug the profile view
    [ChatUIManager getInstance].pushProfileCallback = ^(ChatUser *user, ChatMessagesVC *vc) {
        UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"HelloChat" bundle:nil];
        UINavigationController *profileNC = [profileSB instantiateViewControllerWithIdentifier:@"user-profile-vc"];
        HelloUserProfileTVC *profileVC = (HelloUserProfileTVC *)[[profileNC viewControllers] objectAtIndex:0];
        HelloUser *hello_user = [[HelloUser alloc] init];
        hello_user.userid = user.userId;
        hello_user.username = user.userId;
        hello_user.fullName = user.fullname;
        NSLog(@"fullname: %@", user.fullname);
        profileVC.user = hello_user;
        [vc.navigationController pushViewController:profileVC animated:YES];
    };
    // plug the contact selection view
    // plug the create group view
    // plug the groups' list view
    // plug the browser view
    // plug the show image view
}

+(void)firebaseAuthEmail:(NSString *)email password:(NSString *)password completion:(void (^)(FIRUser *fir_user, NSError *))callback {
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Firebase Auth error for email %@/%@: %@", email, password, error);
            callback(nil, error);
        }
        else {
            FIRUser *user = authResult.user;
            NSLog(@"Firebase Auth success. email: %@, emailverified: %d, userid: %@", user.email, user.emailVerified, user.uid);
            callback(user, nil);
        }
//        if (!user.emailVerified) {
//            NSLog(@"Email non verificata. Invio email verifica...");
//                [user sendEmailVerificationWithCompletion:^(NSError * _Nullable error) {
//                NSLog(@"Email verifica inviata.");
//        }
    }];
}


@end
