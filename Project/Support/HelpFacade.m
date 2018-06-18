//
//  HelpFacade.m
//  bppmobile
//
//  Created by Andrea Sponziello on 05/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelpFacade.h"
#import "HelloAppDelegate.h"
#import "HelloApplicationContext.h"
#import "HelpCategoryStepTVC.h"
#import "ChatUser.h"
#import "ChatUtil.h"
#import "HelpCategory.h"
#import <sys/utsname.h>
#import "HelpDescriptionStepTVC.h"
#import "ChatUIManager.h"

static HelpFacade *sharedInstance = nil;

@implementation HelpFacade

-(id)init {
    if (self = [super init]) {
        // init code
    }
    return self;
}

+(HelpFacade *)sharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super alloc] init];
        HelloAppDelegate *appDelegate = (HelloAppDelegate *)[[UIApplication sharedApplication] delegate];
        HelloApplicationContext *applicationContext = appDelegate.applicationContext;
        BOOL support_enabled = [[applicationContext.settings valueForKey:@"chat-support"] boolValue];
        sharedInstance.supportEnabled = support_enabled;
    }
    return sharedInstance;
}

-(void)activateSupportBarButton:(UIViewController *)vc {
    if (self.supportEnabled) {
        //vc.navigationItem.leftBarButtonItem = nil;
        UIImage *image = [UIImage imageNamed:@"ic_linear_support_gray_01"];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:vc action:@selector(helpAction:)];
        vc.navigationItem.leftBarButtonItem  = button;
    }
}

-(void)openSupportView:(UIViewController *)sourcevc {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Help_request" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"help-wizard"];
    HelpCategoryStepTVC *firstStep = (HelpCategoryStepTVC *)[[nc viewControllers] objectAtIndex:0];
    firstStep.context = [[NSMutableDictionary alloc] init];
    [firstStep.context setObject:sourcevc forKey:@"view-controller"];
    [sourcevc presentViewController:nc animated:YES completion:nil];
}

-(void)handleWizardSupportFromViewController:(UIViewController *)vc helpContext:(NSDictionary *)context {
    UIViewController *sourceViewController = (UIViewController *)[context objectForKey:@"source-view-controller"];
    if (![sourceViewController isKindOfClass:[HelpDescriptionStepTVC class]]) {
        NSLog(@"Help wizard canceled.");
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        [vc dismissViewControllerAnimated:YES completion:^{
            NSString *section = [context objectForKey:@"section"];
            [[HelpFacade sharedInstance] chatAction:context fromSection:section];
        }];
    }
}

-(void)chatAction:(NSDictionary *)context fromSection:(NSString *)section {
    NSLog(@"Passing control to support agent");
    HelpCategory *cat = [context objectForKey:@"category"];
    // Agent user
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Help-Info" ofType:@"plist"]];
    NSString *client = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey]; //[dictionary objectForKey:@"client-name"];
    NSString *cat_name = cat.nameInCurrentLocale;
    NSString *cat_id = cat.pathId;
    NSString *description = [context objectForKey:@"description"];
    NSString *platform = [[NSString alloc] initWithFormat:@" %@/%@", [HelpFacade deviceName], [[UIDevice currentDevice] systemVersion] ]; //"iPhone 6/11.0.2";
    NSDictionary *attributes = @{
                                 @"cat_id" : cat_id,
                                 @"cat_name" : cat_name,
                                 @"description": description,
                                 @"client": client,
                                 @"platform": platform,
                                 @"section": section
                                 };
    // Agent user
    NSString *main_agent_id = [dictionary objectForKey:@"main-agent-id"];
    NSString *main_agent_name = [dictionary objectForKey:@"main-agent-name"];
    ChatUser *support_user = [[ChatUser alloc] init:main_agent_id fullname:main_agent_name];
    [[HelpFacade sharedInstance] sendMessage:description toRecipient:support_user attributes:attributes];
}

-(void)sendMessage:(NSString *)text toRecipient:(ChatUser *)recipient attributes:(NSDictionary *)attributes {
    NSInteger chat_tab_index = [ChatUIManager getInstance].tabBarIndex; //[HelloApplicationContext tabIndexByName:@"ChatController"];
    // move to the converstations tab
    if (chat_tab_index >= 0) {
        [ChatUIManager moveToConversationViewWithUser:recipient orGroup:nil sendMessage:text attributes:attributes];
    }
}

+(NSString*)deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

@end
