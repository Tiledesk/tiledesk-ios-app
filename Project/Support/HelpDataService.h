//
//  HelpDataService.h
//  chat21
//
//  Created by Andrea Sponziello on 29/05/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HelpDepartment;

@interface HelpDataService : NSObject

+ (NSString *)departmentsService;
- (void)downloadDepartmentsWithCompletionHandler:(void(^)(NSArray<HelpDepartment *> *departments, NSError *error))callback;

@end
