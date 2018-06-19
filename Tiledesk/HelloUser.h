//
//  HelloUser.m
//
//  Created by andrea sponziello on 10/12/17.
//

#import <Foundation/Foundation.h>

@interface HelloUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;

-(NSString *)displayName;

@end
