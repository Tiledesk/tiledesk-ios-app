//
//  HelloLocale.m
//  chat21
//
//  Created by Andrea Sponziello on 10/08/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "HelloLocale.h"

@implementation HelloLocale

+(NSString *)translate:(NSString *)key {
    //    NSLog(@"translate: %@ with: %@", key, NSLocalizedStringFromTable(key, @"Chat", nil));
    return NSLocalizedStringFromTable(key, @"Localizable", nil);
}

@end
