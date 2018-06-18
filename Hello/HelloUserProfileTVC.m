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

@interface HelloUserProfileTVC ()

@end

@implementation HelloUserProfileTVC

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
