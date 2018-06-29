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
    NSString *host = [dictionary objectForKey:@"host"];
    NSString *authService = [dictionary objectForKey:@"auth-service"];
    NSString *service = [NSString stringWithFormat:@"%@%@", host, authService];
    NSLog(@"auth service url: %@", service);
    return service;
}

+(void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(HelloUser *user, NSError *))callback {
    [TiledeskAppService loginForFirebaseTokenWithEmail:email password:password completion:^(NSString *token, NSError *error) {
        if (error) {
            callback(nil, error);
        }
        else {
            [ChatAuth authWithCustomToken:token completion:^(ChatUser *user, NSError *error) {
                if (error) {
                    NSLog(@"Authentication error. %@", error);
                    callback(nil, error);
                }
                else {
                    NSLog(@"Authentication success.");
                    HelloUser *signedUser = [[HelloUser alloc] init];
                    signedUser.userid = user.userId;
                    signedUser.username = user.email;
                    signedUser.email = user.email;
                    signedUser.password = password;
                    callback(signedUser, nil);
                }
            }];
        }
    }];
}

+(void)loginForFirebaseTokenWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSString *token, NSError *error))callback {
    NSString *auth_url = [TiledeskAppService authService];
    NSLog(@"CUSTOM AUTH URL: %@", auth_url);
    NSLog(@"email: %@", email);
//    NSLog(@"pwd: %@", password);
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
            NSLog(@"firebase auth ERROR: %@", error);
            callback(nil, error);
        }
        else {
            NSString *token = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"token response: %@", token);
            callback(token, nil);
        }
    }];
    [task resume];
}

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
