//
//  TiledeskAppService.h
//  tiledesk
//
//  Created by Andrea Sponziello on 19/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HelloUser;
//@class ChatConversation;

@interface TiledeskAppService : NSObject

+(NSString *)authService;
+(NSString *)archiveConversationService:(NSString *)conversationId;
+(NSString *)archiveAndCloseSupportConversationService:(NSString *)conversationId;

+(void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(HelloUser *user, NSError *))callback;
+(void)signinWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *json, NSError *))callback;
//+(void)loginForFirebaseTokenWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *json, NSError *error))callback;
+(void)getFirebaseTokenWithTiledeskToken:(NSString *)tiledeskToken completion:(void (^)(NSString *firebaseToken, NSError *error))callback;
//+(void)archiveConversation:(ChatConversation *)conversation completion:(void (^)(NSError *error))callback;

@end
