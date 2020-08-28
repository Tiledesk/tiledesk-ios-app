//
//  TiledeskAppService.m
//  tiledesk
//
//  Created by Andrea Sponziello on 19/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "TiledeskAppService.h"
#import "ChatUser.h"
#import "ChatAuth.h"
#import "HelloUser.h"
//#import "ChatConversation.h"
//#import "ChatManager.h"

@implementation TiledeskAppService

-(id)init {
    self = [super init];
    if (self) {
        // Init code
    }
    return self;
}

+ (NSString *)authService {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
    NSString *host = [dictionary objectForKey:@"auth-service-host"];
    NSString *authService = [dictionary objectForKey:@"auth-service-path"];
    NSString *service = [NSString stringWithFormat:@"%@%@", host, authService];
    NSLog(@"auth service url: %@", service);
    return service;
}

+ (NSString *)firebaseCustomTokenUrl {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
    NSString *host = [dictionary objectForKey:@"auth-service-host"];
    NSString *firebaseAuthService = [dictionary objectForKey:@"firebase-custom-token-path"];
    NSString *service = [NSString stringWithFormat:@"%@%@", host, firebaseAuthService];
    NSLog(@"firebaseAuthService url: %@", service);
    return service;
}

//+(NSString *)archiveConversationService:(NSString *)conversationId {
//    // https://us-central1-chat-v2-dev.cloudfunctions.net/api/tilechat/conversations/support-group-LGdXjl_T98q_Kz3ycdJ
//    NSString *tenant = [ChatManager getInstance].tenant;
//    NSString *url = [[NSString alloc] initWithFormat:@"https://us-central1-chat-v2-dev.cloudfunctions.net/api/%@/conversations/%@", tenant, conversationId];
//    return url;
//}
//
//+(NSString *)archiveAndCloseSupportConversationService:(NSString *)conversationId {
//    // https://us-central1-chat-v2-dev.cloudfunctions.net/supportapi/tilechat/groups/support-group-LG9WBQE2mkIKVIhZmHW
//    NSString *tenant = [ChatManager getInstance].tenant;
//    NSString *url = [[NSString alloc] initWithFormat:@"https://us-central1-chat-v2-dev.cloudfunctions.net/supportapi/%@/groups/%@", tenant, conversationId];
//    return url;
//}

+(void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(HelloUser *user, NSError *))callback {
    [TiledeskAppService signinWithEmail:email password:password completion:^(NSDictionary *jsonResponse, NSError *error) {
        NSLog(@"Logged in with email");
        if (error) {
            callback(nil, error);
        }
        else {
            NSString *tiledeskToken = [jsonResponse objectForKey:@"token"];
            NSLog(@"tiledeskToken: %@", tiledeskToken);
            
            [TiledeskAppService getFirebaseTokenWithTiledeskToken:(NSString *)tiledeskToken completion:^(NSString *firebaseToken, NSError *error) {
                NSLog(@"FirebaseToken: %@", firebaseToken);
                [ChatAuth authWithCustomToken:firebaseToken completion:^(ChatUser *user, NSError *error) {
                    if (error) {
                        NSLog(@"Authentication error. %@", error);
                        callback(nil, error);
                    }
                    else {
                        NSLog(@"Authentication success.");
                        HelloUser *signedUser = [[HelloUser alloc] init];
                        signedUser.userid = user.userId;
                        signedUser.username = user.email;
                        signedUser.firstName = jsonResponse[@"user"][@"firstname"];
                        signedUser.lastName = jsonResponse[@"user"][@"lastname"];
                        signedUser.fullName = [[NSString stringWithFormat:@"%@ %@", signedUser.firstName, signedUser.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        // Registration with custom token returns firebase's users without email.
                        // Using provided login form email to save user's email.
                        signedUser.email = user.email != nil ? user.email : email;
                        signedUser.password = password;
                        callback(signedUser, nil);
                    }
                }];
            }];
        }
    }];
}

+(void)signinWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSDictionary *json, NSError *error))callback {
    NSString *auth_url = [TiledeskAppService authService];
    
    NSDictionary* dict = @{
                           @"email": email,
                           @"password": password
                           };
    NSData *jsonData = [TiledeskAppService dictAsJSON:dict];
    NSURL *url = [NSURL URLWithString:auth_url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Auth ERROR: %@", error);
            callback(nil, error);
        }
        else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Tiledesk Auth JSON Response: %@", responseString);
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            callback(json, nil);
        }
    }];
    [task resume];
}

+(void)getFirebaseTokenWithTiledeskToken:(NSString *)tiledeskToken completion:(void (^)(NSString *firebaseToken, NSError *error))callback {
    NSString *firebase_custom_token_url = [TiledeskAppService firebaseCustomTokenUrl];
    
//    NSDictionary* dict = @{
//                           @"email": email,
//                           @"password": password
//                           };
//    NSData *jsonData = [TiledeskAppService dictAsJSON:dict];
    NSURL *url = [NSURL URLWithString:firebase_custom_token_url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:tiledeskToken forHTTPHeaderField:@"authorization"];
    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:jsonData];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"firebase auth ERROR: %@", error);
            callback(nil, error);
        }
        else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"responseString: %@", responseString);
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            callback(responseString, nil);
        }
    }];
    [task resume];
}

//+(void)archiveConversation:(ChatConversation *)conversation completion:(void (^)(NSError *error))callback {
//    
//    FIRUser *fir_user = [FIRAuth auth].currentUser;
//    [fir_user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error while getting current FIrebase token: %@", error);
//            callback(error);
//            return;
//        }
//        NSString *service_url = [TiledeskAppService archiveConversationService:conversation.conversationId];
//        NSLog(@"URL: %@", service_url);
//        NSURL *url = [NSURL URLWithString:service_url];
//        NSURLSession *session = [NSURLSession sharedSession];
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                           timeoutInterval:60.0];
//        [request addValue:token forHTTPHeaderField:@"Authorization"];
//        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPMethod:@"DELETE"];
//        
//        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (error) {
//                NSLog(@"firebase auth ERROR: %@", error);
//                callback(error);
//            }
//            else {
//                NSString *token = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//                NSLog(@"token response: %@", token);
//                callback(nil);
//            }
//        }];
//        [task resume];
//    }];
//}

+(NSData *)dictAsJSON:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"JSON String: %@", jsonString);
        return jsonData;
    }
}

@end
