//
//  HelloApplicationContext.m
//
//  Created by andrea sponziello on 08/08/17.
//
//

#import "HelloApplicationContext.h"
#import "HelloAuth.h"
#import "HelloUser.h"

@implementation HelloApplicationContext

static HelloApplicationContext *sharedInstance = nil;

+(HelloApplicationContext *)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    return self;
}

- (void)signout {
    [HelloAuth deleteSignedinUser];
    self.loggedUser = nil;
}

-(void)signin:(HelloUser *)user {
    [HelloAuth deleteSignedinUser];
    [HelloAuth saveSignedinUser:user];
    self.loggedUser = user;
    NSLog(@"%@ signed in.", self.loggedUser.username);
}

@end

