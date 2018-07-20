//
//  HelloMyProfileTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 19/07/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloMyProfileTVC.h"
#import "HelloApplicationContext.h"
#import "ChatManager.h"
//#import "ChatRootNC.h"
#import "HelloUser.h"
#import "HelloAppDelegate.h"
#import "ChatUtil.h"
#import "ChatManager.h"
#import "ChatUser.h"
#import "HelpFacade.h"
#import "HelloAuthTVC.h"

@interface HelloMyProfileTVC ()

@end

@implementation HelloMyProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = [NSString stringWithFormat:@"ver. %@ build %@", version, build];
    HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.appNameLabel.text = [app.applicationContext.settings objectForKey:@"app-name"];
    
    [[HelpFacade sharedInstance] activateSupportBarButton:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) { // cella supporto
        if (![HelpFacade sharedInstance].supportEnabled) {
            return 0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)logoutAction:(id)sender {
    NSLog(@"Logout action");
    UIAlertController * view =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:NSLocalizedString(@"Want you exit", nil)
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* logout = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Yes", nil)
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Sending request");
                                 [self confirmLogout];
                             }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", nil)
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"action canceled");
                             }];
    [view addAction:logout];
    [view addAction:cancel];
    // for ipad
    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:view animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    HelloUser *loggedUser = [HelloApplicationContext getSharedInstance].loggedUser;
    self.usernameLabel.text = loggedUser.username;
    self.useridLabel.text = loggedUser.userid;
    self.emailLabel.text = loggedUser.email;
    self.fullNameLabel.text = loggedUser.displayName;
}

- (void)confirmLogout {
    NSLog(@"LOGOUT");
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
    HelloApplicationContext *context = app.applicationContext;
    [context signout];
    [self resetTab];
    
    // LOGOUT FIREBASE...
    //START SIGNOUT
    ChatManager *chatm = [ChatManager getInstance];
    [chatm dispose];
    //signout firebase
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    NSLog(@"logut status %d, error: %@", status, signOutError);
    if (!status) {
        NSLog(@"Error signing out from Firebase: %@", signOutError);
    }
    else {
        NSLog(@"Successfully signed out from Firebase");
    }
}

-(void)resetTab {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabController = (UITabBarController *)window.rootViewController;
    tabController.selectedIndex = 0;
    [HelloMyProfileTVC showLoginModalOnFirstTab];
}

+(void)showLoginModalOnFirstTab {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UITabBarController *tabController = (UITabBarController *)window.rootViewController;
    NSArray *controllers = [tabController viewControllers];
    UIViewController *firstTabController = controllers[0];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Tiledesk" bundle:nil];
    HelloAuthTVC *vc = (HelloAuthTVC *)[sb instantiateViewControllerWithIdentifier:@"login-vc"];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [firstTabController presentViewController:vc animated:NO completion:nil];
}
- (IBAction)helpAction:(id)sender {
    NSLog(@"Help in %@ view.", NSStringFromClass([self class]));
    [[HelpFacade sharedInstance] openSupportView:self];
}

-(void)helpWizardEnd:(NSDictionary *)context {
    NSLog(@"helpWizardEnd");
    [context setValue:NSStringFromClass([self class]) forKey:@"section"];
    [[HelpFacade sharedInstance] handleWizardSupportFromViewController:self helpContext:context];
}

@end
