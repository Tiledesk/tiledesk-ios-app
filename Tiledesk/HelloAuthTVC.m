//
//  HelloAuthTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 19/07/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloAuthTVC.h"
#import "HelloApplicationContext.h"
#import "HelloUser.h"
#import "ChatProgressView.h"
#import "HelloAppDelegate.h"
#import "ChatUser.h"
#import "ChatManager.h"
#import "HelloChatUtil.h"
#import "TiledeskAppService.h"
#import "TiledeskLocal.h"
@import Firebase;

@interface HelloAuthTVC () {
    ChatProgressView *HUD;
}
@end

@implementation HelloAuthTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.usernameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *appName = [app.applicationContext.settings objectForKey:@"app-name"];
    self.navigationItem.title = appName;
    self.hintLabel.text = [TiledeskLocal translate:@"hintLogin"];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)textFieldDidChange :(UITextField *) textField {
    NSString *text = textField.text;
    if (textField == self.usernameTextField) {
        //        NSLog(@"UsernameText di change %@", textField.text);
        if (text.length > 0) {
            [self animateView:self.usernameLabel hidden:NO];
            //            self.usernameLabel.hidden = NO;
        } else {
            [self animateView:self.usernameLabel hidden:YES];
            //            self.usernameLabel.hidden = YES;
        }
    }
    
    
    if (textField == self.passwordTextLabel) {
        //        NSLog(@"PasswordText di change %@", textField.text);
        if (text.length > 0) {
            [self animateView:self.passwordLabel hidden:NO];
            //            self.passwordLabel.hidden = NO;
        } else {
            [self animateView:self.passwordLabel hidden:YES];
            //            self.passwordLabel.hidden = YES;
        }
    }
}

-(void)animateView:(UIView *)view hidden:(BOOL)hidden {
    [UIView transitionWithView:view
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        view.hidden = hidden;
                    }
                    completion:NULL];
}

-(void)viewWillAppear:(BOOL)animated {
    self.loginButton.enabled = true;
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *stored_username = [userPreferences stringForKey:@"stored_username"];
    NSString *stored_password = [userPreferences stringForKey:@"stored_password"];
    
    NSLog(@"%@ %@", stored_username, stored_password);
    if (![stored_username isEqualToString:@""] && ![stored_password isEqualToString:@""]) {
        self.usernameTextField.text = stored_username;
        self.passwordTextLabel.text = stored_password;
    }
    //    self.usernameTextField.text = @"test.monitoraggio";
    //    self.passwordTextLabel.text = @"123456";
}

-(void)showWaiting:(NSString *)label {
    if (!HUD) {
        HUD = [[ChatProgressView alloc] initWithWindow:self.view.window];
        [self.view.window addSubview:HUD];
    }
    HUD.center = self.view.center;
    HUD.labelText = label;
    HUD.animationType = ChatProgressViewAnimationZoom;
    [HUD show:YES];
}

-(void)hideWaiting {
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSString *email = self.usernameTextField.text;
    NSString *password = self.passwordTextLabel.text;
    
    NSString *trimmed_email= [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmed_password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmed_password isEqualToString:@""] || [trimmed_email isEqualToString:@""]) {
        return;
    }
    
    self.loginButton.enabled = false;
    [self showWaiting:[TiledeskLocal translate:@"authenticating"]];
    [self firebaseLogin:email password:password];
}

- (IBAction)registerAction:(id)sender {
    NSLog(@"Register");
}

-(void)firebaseLogin:(NSString *)email password:(NSString *)password {
    
    HelloAppDelegate *appDelegate = (HelloAppDelegate *)[[UIApplication sharedApplication] delegate];
    HelloApplicationContext *context = appDelegate.applicationContext;
    
    __weak HelloAuthTVC *weakSelf = self;
    
    [TiledeskAppService loginWithEmail:email password:password completion:^(HelloUser *signedUser, NSError *error) {
        if (error) {
            NSLog(@"Authentication error. %@", error);
            NSLog(@"Firebase auth error: %@", error);
            weakSelf.loginButton.enabled = true;
            [weakSelf hideWaiting];
            [self showAlert:[TiledeskLocal translate:@"authentication error"]];
        }
        else {
            NSLog(@"Authentication success. user.id: %@, user.email: %@, user.password: ****", signedUser.userid, signedUser.email);
//            HelloUser *signedUser = [[HelloUser alloc] init];
//            signedUser.userid = fir_user.uid;
//            signedUser.username = fir_user.email;
//            signedUser.email = email;
//            signedUser.password = password;

            // store user info for next login.
            // REMOVE ON PRODUCTION. HERE JUST TO ACCELERATE DEVELOPMENT
//            NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
//
//            [userPreferences setObject:password forKey:@"stored_password"];
//            [userPreferences setObject:email forKey:@"stored_username"];
//            [userPreferences synchronize];

            ChatManager *chatm = [ChatManager getInstance];
            [chatm getContactLocalDB:signedUser.userid withCompletion:^(ChatUser *user) {
                if (user) {
                    signedUser.firstName = user.firstname;
                    signedUser.lastName = user.lastname;
                    [context signin:signedUser];
                    [weakSelf hideWaiting];
                    [self initChatAndCloseView:weakSelf];
                }
                else {
                    [chatm getUserInfoRemote:signedUser.userid withCompletion:^(ChatUser *user) {
                        signedUser.firstName = user.firstname;
                        signedUser.lastName = user.lastname;
                        [context signin:signedUser];
                        [weakSelf hideWaiting];
                        [self initChatAndCloseView:weakSelf];
                    }];
                }
            }];
        }
    }];
}

-(void)initChatAndCloseView:(HelloAuthTVC *)weakSelf {
    [HelloChatUtil initChat];
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
        HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
        [app startPushNotifications];
    }];
}

-(void)showAlert:(NSString *)msg {
    UIAlertController * view =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"action canceled");
                             }];
    [view addAction:cancel];
    // for ipad
    view.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:view animated:YES completion:nil];
}

@end

