//
//  HelloApplicationContext.h
//  Shopper
//
//  Created by andrea sponziello on 08/08/17.
//
//

#import <Foundation/Foundation.h>

@class HelloUser;

@interface HelloApplicationContext: NSObject

@property (strong, nonatomic) HelloUser *loggedUser;
@property (nonatomic, strong) NSDictionary *settings;

- (void)signout;
- (void)signin:(HelloUser *)user;

+(HelloApplicationContext *)getSharedInstance;

@end
