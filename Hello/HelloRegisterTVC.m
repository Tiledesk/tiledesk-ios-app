//
//  HelloRegisterTVC.m
//  chat21
//
//  Created by Andrea Sponziello on 14/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelloRegisterTVC.h"
#import "ChatProgressView.h"
#import "HelloApplicationContext.h"
#import "HelloUser.h"
#import "ChatUser.h"
#import "ChatManager.h"
#import "HelloChatUtil.h"
#import "HelloAppDelegate.h"

@import Firebase;

@interface HelloRegisterTVC () {
    ChatProgressView *HUD;
}
@end

@implementation HelloRegisterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    NSLog(@"Registering");
    
    NSString *_email = self.usernameTextField.text;
    NSString *_password1 = self.passwordTextField.text;
    NSString *_password2 = self.repeatPasswordTextfield.text;
    NSString *_firstname = self.firstnameTextField.text;
    NSString *_lastname = self.lastnameTextField.text;
    
    NSString *email= [_email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password1 = [_password1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password2 = [_password2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstname = [_firstname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [_lastname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *message = [self validateEmail:email password1:password1 password2:password2 firstname:firstname lastname:lastname];
    
    if (message) {
        [self alert:message];
        return;
    }
    
    [self showWaiting:@"Registering..."];
    
    NSString *password = password1;
    
    HelloApplicationContext *context = [HelloApplicationContext getSharedInstance];
    
    __weak HelloRegisterTVC *weakSelf = self;
    
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
         [weakSelf hideWaiting];
         if (error) {
             [weakSelf hideWaiting];
             NSLog(@"Error creating user %@. Error: %@", email, error);
             NSString *message = [[NSString alloc] initWithFormat:@"Error creating user %@. %@", email, error];
             [self alert:message];
             weakSelf.registerButton.enabled = true;
         }
         else {
             FIRUser *fir_user = authResult.user;
             NSLog(@"User %@ successfully created.", email);
             // AGGIUNGERE FIRSTNAME E LASTNAME IN CONTACTS
             
             HelloUser *signedUser = [[HelloUser alloc] init];
             signedUser.userid = fir_user.uid;
             signedUser.username = fir_user.uid;
             signedUser.email = email;
             signedUser.password = password;
             signedUser.firstName = firstname;
             signedUser.lastName = lastname;
             [context signin:signedUser];
             NSLog(@"first name: %@", context.loggedUser.firstName);
             
             // store user info for next login (DANGEROUS! JUST FOR TESTING)
             NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
             [userPreferences setObject:password forKey:@"stored_password"];
             [userPreferences setObject:email forKey:@"stored_username"];
             [userPreferences synchronize];
             
             [HelloChatUtil initChat];
             ChatManager *chat = [ChatManager getInstance];
             [chat createContactFor:chat.loggedUser withCompletionBlock:^(NSError *error) {
                 if (error) {
                     NSLog(@"Error in contact creation after login. User: %@, Error: %@", chat.loggedUser.fullname, error);
                 }
                 else {
                     NSLog(@"Successfully created contact: %@", chat.loggedUser.fullname);
                     NSLog(@"first name: %@", context.loggedUser.firstName);
                 }
             }];
             
             [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                 HelloAppDelegate *app = (HelloAppDelegate *) [[UIApplication sharedApplication] delegate];
                 [app startPushNotifications];
             }];
         }
     }];
}

-(void)alert:(NSString *)message {
    UIAlertController * menu =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {}];
    
    [menu addAction:ok];
    [self presentViewController:menu animated:YES completion:nil];
}

-(NSString *)validateEmail:(NSString *)email password1:(NSString *)password1 password2:(NSString *)password2 firstname:(NSString *)firstname lastname:(NSString *)lastname {
    
    if ([firstname isEqualToString:@""]) {
        return @"First name can't be empty";
    }
    if (![self isValidEmail:email]) {
        return @"Invalid email address.";
    }
    if ([password1 length] < 6) {
        return @"Password must be at least six characters long.";
    }
    if (![password1 isEqualToString:password2]) {
        return @"Repeat the same password.";
    }
    
    return nil;
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

// ALTERNATIVE:

//- (BOOL) isValidEmail:(NSString*) emailString {
//    NSLog(@"Validating email: %@", emailString);
//    if([emailString length]==0){
//        return NO;
//    }
//
//    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//
//    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
//
//    NSLog(@"Mathes: %lu", (unsigned long)regExMatches);
//    if (regExMatches == 0) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

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

@end
