//
//  HelpDepartment.h
//  chat21
//
//  Created by Andrea Sponziello on 29/05/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpDepartment : NSObject

@property(strong, nonatomic) NSString *departmentId;
@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic) BOOL isDefault;

@end
