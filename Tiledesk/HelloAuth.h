//
//  HelloAuth.h
//
//  Created by andrea sponziello on 10/09/17.
//

#import <Foundation/Foundation.h>

@class HelloApplicationContext;
@class HelloUser;

@interface HelloAuth : NSObject

+(HelloUser *)restoreSavedUser;
+(void)saveSignedinUser:(HelloUser *)user;
+(void)deleteSignedinUser;

@end
