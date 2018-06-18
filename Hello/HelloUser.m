//
//  HelloUser.m
//
//  Created by andrea sponziello on 10/12/17.
//

#import "HelloUser.h"

@implementation HelloUser

//-(NSString *)photoUrl {
//    return [SHPUser photoUrlByUsername:self.username];
//}

-(NSString *)displayName {
    NSString *displayName;
    // use fullname if available
    if (self.fullName) {
        NSString *trimmedFullname = [self.fullName stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];
        if (trimmedFullname.length > 0) {
            displayName = trimmedFullname;
        }
        
    }
    else if (!displayName && (self.firstName || self.lastName)) {
        displayName = [[NSString alloc] initWithFormat:@"%@ %@", (self.firstName ? self.firstName : @""), (self.lastName ? self.lastName : @"")];
        displayName = [displayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else {
        displayName = self.username;
    }
    return displayName;
}

@end
