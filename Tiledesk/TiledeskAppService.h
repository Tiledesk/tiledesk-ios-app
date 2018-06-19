//
//  TiledeskAppService.h
//  tiledesk
//
//  Created by Andrea Sponziello on 19/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HelloUser;

@interface TiledeskAppService : NSObject

+ (NSString *)authService;
+(void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(HelloUser *user, NSError *))callback;
+(void)loginForFirebaseTokenWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *token, NSError *error))callback;

@end
