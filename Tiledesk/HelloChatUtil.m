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
    NSLog(@"CHATUSER.FULLNAME %@ FIRSTNAME: %@", chatUser.fullname, chatUser.firstname);
    ChatManager *chatm = [ChatManager getInstance];
    [chatm startWithUser:chatUser];
    
    ChatConversationsVC *conversationsVC = [HelloChatUtil getConversationsVC];
    NSLog(@"conversationsVC: %@ class: %@", conversationsVC, NSStringFromClass([conversationsVC class]));
    if (conversationsVC) {
        [conversationsVC initializeWithSignedUser];
    }
    
//    NSLog(@"Updates user from local contacts synch...");
//    [chatm getContactLocalDB:chatUser.userId withCompletion:^(ChatUser *user) {
//        NSLog(@"user found: %@, user_id: %@, user.firstname: %@", user, user.userId, user.firstname);
//        if (user && user.userId && ![user.firstname isEqualToString:@""]) {
//            chatUser.firstname = user.firstname;
//            chatUser.lastname = user.lastname;
//            app.applicationContext.loggedUser.firstName = user.firstname;
//            app.applicationContext.loggedUser.lastName = user.lastname;
//            [app.applicationContext signin:app.applicationContext.loggedUser];
//        }
//    }];
    // plug the profile view
    [ChatUIManager getInstance].pushProfileCallback = ^(ChatUser *user, ChatMessagesVC *vc) {
        UIStoryboard *profileSB = [UIStoryboard storyboardWithName:@"Tiledesk" bundle:nil];
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

+(ChatConversationsVC *)getConversationsVC {
    NSInteger chat_tab_index = [ChatUIManager getInstance].tabBarIndex;
    NSLog(@"chat_tab_index %ld", (long)chat_tab_index);
    if (chat_tab_index >= 0) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UITabBarController *tabController = (UITabBarController *)window.rootViewController;
        NSLog(@"tabController: %@ class: %@", tabController, NSStringFromClass([tabController class]));
        NSMutableArray *controllers = [[tabController viewControllers] mutableCopy];
        NSLog(@"controllers: %@ class: %@", controllers, NSStringFromClass([controllers class]));
//        UINavigationController *conversationsNC = [[ChatUIManager getInstance] getConversationsViewController];
//        conversationsNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chat" image:[UIImage imageNamed:@"ic_linear_chat"] selectedImage:[UIImage imageNamed:@"ic_linear_chat"]];
//        controllers[chat_tab_index] = conversationsNC;
//        [tabController setViewControllers:controllers];
        UINavigationController *conversationsNC = (UINavigationController *)controllers[chat_tab_index];
        NSLog(@"conversationsNC: %@ class: %@", conversationsNC, NSStringFromClass([conversationsNC class]));
        ChatConversationsVC *conversationsVC = conversationsNC.viewControllers[0];
        NSLog(@"conversationsVC: %@ class: %@", conversationsVC, NSStringFromClass([conversationsVC class]));
        return conversationsVC;
    }
    return nil;
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
