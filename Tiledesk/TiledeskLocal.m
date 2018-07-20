//
//  TiledeskLocal.m
//  tiledesk
//
//  Created by Andrea Sponziello on 20/07/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "TiledeskLocal.h"

@implementation TiledeskLocal

+(NSString *)translate:(NSString *)key {
    //    NSLog(@"translate: %@ with: %@", key, NSLocalizedStringFromTable(key, @"Chat", nil));
    return NSLocalizedStringFromTable(key, @"Localizable", nil);
}

@end
