//
//  HelloRegisterTVC.h
//  chat21
//
//  Created by Andrea Sponziello on 14/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloRegisterTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)registerAction:(id)sender;

@end
