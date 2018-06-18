//
//  HelloVC.m
//  chat21
//
//  Created by Andrea Sponziello on 05/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloVC.h"
#import "HelloUser.h"
#import "HelloAppDelegate.h"
#import "HelloApplicationContext.h"
#import "HelloAuthTVC.h"
#import "HelpFacade.h"
#import "ChatUIManager.h"
#import "ChatUser.h"

@interface HelloVC ()

@end

@implementation HelloVC

- (void)viewDidLoad {
    [super viewDidLoad];
    HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
    self.appName.text = [app.applicationContext.settings objectForKey:@"app-name"];
    [self.selectContactButton setTitle:NSLocalizedString(@"select a contact", nil) forState:UIControlStateNormal];
    [[HelpFacade sharedInstance] activateSupportBarButton:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    // here just to reduce the time that home controller is visible during signin out.
    HelloAppDelegate *appDelegate = (HelloAppDelegate *)[[UIApplication sharedApplication] delegate];
    HelloUser *loggedUser = appDelegate.applicationContext.loggedUser;
    if (!loggedUser) {
        [self showLoginView];
        return;
    }
}

-(void)showLoginView {
    NSLog(@"PRESENTING LOGIN VIEW.");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"HelloChat" bundle:nil];
    HelloAuthTVC *vc = (HelloAuthTVC *)[sb instantiateViewControllerWithIdentifier:@"login-vc"];
    NSLog(@"vc = %@", vc);
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)helpAction:(id)sender {
    NSLog(@"Help in Home menu view.");
    [[HelpFacade sharedInstance] openSupportView:self];
}

//-(void)helpWizardEnd:(NSDictionary *)context {
//    NSLog(@"helpWizardEnd");
//    [context setValue:NSStringFromClass([self class]) forKey:@"section"];
//    [[HelpFacade sharedInstance] handleWizardSupportFromViewController:self helpContext:context];
//}

- (IBAction)openConversationsAction:(id)sender {
    [[ChatUIManager getInstance] openConversationsViewAsModal:self withCompletionBlock:^{
        NSLog(@"Conversations view dismissed.");
    }];
}

- (IBAction)openConversationWithSomeone:(id)sender {
    ChatUser *recipient = [[ChatUser alloc] init:@"y4QN01LIgGPGnoV6ql07hwPAQg23" fullname:@"Andrew Sponzillo"];
    [[ChatUIManager getInstance] openConversationMessagesViewAsModalWith:(ChatUser *)recipient viewController:self attributes:nil withCompletionBlock:^{
        NSLog(@"Messages view dismissed.");
    }];
}

- (IBAction)selectContactAction:(id)sender {
    NSLog(@"Selecting contact");
    [[ChatUIManager getInstance] openSelectContactViewAsModal:self withCompletionBlock:^(ChatUser *contact, BOOL canceled) {
        if (canceled) {
            NSLog(@"Select Contact canceled");
        }
        else {
            NSLog(@"Selected contact: %@/%@", contact.fullname, contact.userId);
            NSString *msg = [[NSString alloc] initWithFormat:@"You selected: %@", contact.fullname];
            [self alert:msg];
        }
    }];
}

- (IBAction)selectContactAndConverseAction:(id)sender {
    NSLog(@"Selecting contact");
    [[ChatUIManager getInstance] openSelectContactViewAsModal:self withCompletionBlock:^(ChatUser *contact, BOOL canceled) {
        if (canceled) {
            NSLog(@"Select Contact canceled");
        }
        else {
            NSLog(@"Selected contact: %@/%@", contact.fullname, contact.userId);
            [[ChatUIManager getInstance] openConversationMessagesViewAsModalWith:(ChatUser *)contact viewController:self attributes:nil withCompletionBlock:^{
                NSLog(@"Messages view dismissed.");
            }];
        }
    }];
}

-(void)alert:(NSString *)msg {
    UIAlertController *view = [UIAlertController
                               alertControllerWithTitle:msg
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:nil];
    [view addAction:confirm];
    [self presentViewController:view animated:YES completion:nil];
}

@end
