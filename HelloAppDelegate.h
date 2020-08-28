//
//  HelloAppDelegate.h
//
//  Created by andrea sponziello on 24/05/17.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@class HelloApplicationContext;
@class MBProgressHUD;

@interface HelloAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HelloApplicationContext *applicationContext;

-(void)startPushNotifications;
@property (nonatomic, copy) void (^fetchCompletionHandler)(UIBackgroundFetchResult result);

@end
