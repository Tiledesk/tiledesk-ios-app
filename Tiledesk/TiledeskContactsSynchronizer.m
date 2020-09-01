//
//  TiledeskContactsSynchronizer.m
//  tiledesk
//
//  Created by Andrea Sponziello on 31/08/2020.
//  Copyright © 2020 Frontiere21. All rights reserved.
//

#import "TiledeskContactsSynchronizer.h"
#import "TiledeskAppService.h"
#import "ChatUser.h"
#import "ChatContactsDB.h"

@interface TiledeskContactsSynchronizer ()

@end

@implementation TiledeskContactsSynchronizer

-(id)initWithToken:(NSString *)token { // user:(ChatUser *)user {
    if (self = [super init]) {
        self.token = token;
    }
    return self;
}

-(void)synch {
    [self downloadContacts:self.token completion:^(NSArray *contactsJson, NSError *error) {
        NSLog(@"contacts downloaded %@", contactsJson);
        if (contactsJson.count > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                ChatContactsDB *contactsDB = [ChatContactsDB getSharedInstance];
                [contactsDB deleteAllContacts]; // refreshes all contacts with the downloaded ones
                for (NSDictionary *contactJSON in contactsJson) {
                    NSLog(@"ins contact %@", contactJSON);
                    ChatUser *contact = [TiledeskContactsSynchronizer contactFromDictionaryFactory:contactJSON];
                    [self insertOrUpdateContactOnDB:contact];
                }
            });
        }
    }];
}

-(void)insertOrUpdateContactOnDB:(ChatUser *)user {
    __block ChatUser *_user = user;
    [[ChatContactsDB getSharedInstance] insertOrUpdateContactSyncronized:_user completion:^{
        _user = nil;
    }];
}

-(void)downloadContacts:(NSString *)token completion:(void (^)(NSArray *json, NSError *error))callback {
    NSString *contacts_url = [TiledeskAppService contactsUrl];
    NSURL *url = [NSURL URLWithString:contacts_url];
    // POST DATA
//    NSDictionary* dict = @{
//                           @"email": email,
//                           @"password": password
//                           };
//    NSData *jsonData = [TiledeskAppService dictAsJSON:dict];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:token forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:jsonData];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Auth ERROR: %@", error);
            callback(nil, error);
        }
        else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Tiledesk contacts Response: %@", responseString);
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            callback(json, nil);
        }
    }];
    [task resume];
}

+(ChatUser *)contactFromDictionaryFactory:(NSDictionary *)snapshot {
//    "uid": "5e09d16d4d36110017506d7f",
//    "email": "andreasponziello@tiledesk.com",
//    "firstname": "Andrea",
//    "lastname": "",
//    "description": "Bug fix project, Demo s3c, testwebsocket1, Test Notifications"
    NSString *userId = snapshot[@"uid"];
    if (!userId) { // user_id can t be null
        NSLog(@"ERROR. NO UID. INVALID USER.");
        return nil;
    }
    
    NSString *email = snapshot[@"email"];
    if (!email) {
        email = @"";
    }
    
    NSString *name = snapshot[@"firstname"];
    if (!name) {
        name = @"";
    }
    
    NSString *lastname = snapshot[@"lastname"];
    if (!lastname) {
        lastname = @"";
    }
    
    double createdon = [[NSDate date] timeIntervalSince1970];
    
    ChatUser *contact = [[ChatUser alloc] init];
    contact.firstname = name;
    contact.lastname = lastname;
    contact.userId = userId;
    contact.email = email;
//    if (imagechangedat) {
//        contact.imageChangedAt = [imagechangedat integerValue];
//    }
    contact.createdon = (int)createdon; // firebase timestamp is in millis
    return contact;
}

@end
