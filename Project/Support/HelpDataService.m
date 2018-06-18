//
//  HelpDataService.m
//  chat21
//
//  Created by Andrea Sponziello on 29/05/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "HelpDataService.h"
#import "HelpDepartment.h"

@implementation HelpDataService

-(id)init {
    self = [super init];
    if (self) {
        // Init code
    }
    return self;
}

+ (NSString *)departmentsService {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Help-Info" ofType:@"plist"]];
    NSString *host = [dictionary objectForKey:@"host"];
    NSString *departmentsService = [dictionary objectForKey:@"departments-service"];
    NSString *projectId = [dictionary objectForKey:@"projectId"];
    NSString *departmentServiceURI = [NSString stringWithFormat:NSLocalizedString(departmentsService, nil), projectId];
    NSString *service = [NSString stringWithFormat:@"%@%@", host, departmentServiceURI];
    NSLog(@"departments service url: %@", service);
    return service;
}

- (void)downloadDepartmentsWithCompletionHandler:(void(^)(NSArray<HelpDepartment *> *departments, NSError *error))callback; {
//    NSURLSessionDataTask *currentTask = [self.tasks objectForKey:message.messageId];
//    if (currentTask) {
//        NSLog(@"Image %@ already downloading (messageId: %@).", message.imageURL, message.messageId);
//        return;
//    }
    NSURLSessionConfiguration *_config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *_session = [NSURLSession sessionWithConfiguration:_config];
    NSString *departmentsServiceURL = [HelpDataService departmentsService];
    NSURL *url = [NSURL URLWithString:departmentsServiceURL];
    NSLog(@"Downloading departments JSON. URL: %@", url);
    if (!url) {
        NSLog(@"ERROR - Can't download departments, service URL is null");
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString *authStr = @"andrea.leo@frontiere21.it:123456";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"JSON downloaded: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
        if (error) {
            NSLog(@"%@", error);
            callback(nil, error);
            return;
        }
        if (data) {
            NSArray<HelpDepartment *> *departments = [self JSON2Departments: data];
            if (departments) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(departments, nil);
                });
            }
        }
    }];
    [task resume];
}

- (NSArray<HelpDepartment *> *)JSON2Departments:(NSData *)jsonData {
    NSMutableArray<HelpDepartment *> *departments = [[NSMutableArray alloc] init ];
    NSError* error;
    NSArray *departments_json = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:kNilOptions
                             error:&error];
    for(NSDictionary *dep_json in departments_json) {
        NSString *depId = [dep_json valueForKey:@"_id"];
        NSString *name = [dep_json valueForKey:@"name"];
        BOOL isDefault = [[dep_json valueForKey:@"default"] boolValue];
        
//        NSLog(@"default (%d)boolValue - (%@) prop type: %@",isDefault, [dep_json valueForKey:@"default"], NSStringFromClass([[dep_json valueForKey:@"default"] class]));
        
        HelpDepartment *dep = [[HelpDepartment alloc] init];
        dep.departmentId = depId;
        dep.name = name;
        dep.isDefault = isDefault;
        [departments addObject:dep];
    }
    return departments;
}

@end
