//
//  HelpCategory.m

#import "HelpCategory.h"

@implementation HelpCategory

-(NSString *)nameInCurrentLocale {
    NSString *langID = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode]; // it //[[NSLocale preferredLanguages] objectAtIndex:0]; > it-IT
//    NSLog(@"langID %@", langID);
    NSString *category_name = [self.langs objectForKey:langID];
    if (!category_name) {
        langID = @"en";
        category_name = [self.langs objectForKey:langID];
    }
    return category_name;
}

-(id)initWithDictionary: (NSDictionary *)catDict parent:(HelpCategory *)parent {
    self = [super init];
    if( !self ) return nil;
    
    //NSLog(@"init cat %@", [catDict objectForKey:@"id"]);
    
    self.langs = [[NSMutableDictionary alloc] init];
    [self.langs setValue:[catDict objectForKey:@"en"] forKey:@"en"];
    [self.langs setValue:[catDict objectForKey:@"it"] forKey:@"it"];
    self.categoryId = [catDict objectForKey:@"id"];
    self.imageName = [catDict objectForKey:@"imageName"];
    if (parent) {
        self.pathId = [[NSString alloc] initWithFormat:@"%@/%@", parent.pathId, self.categoryId];
        //NSLog(@"pathId from parent-> self.categoryId %@ , self.pathId = %@", self.categoryId, parent.pathId);
    }
    else {
        // for root category, pathID = categoryId
        self.pathId = self.categoryId;
        //NSLog(@"root pathId->  self.pathId = %@", self.pathId);
    }
    NSLog(@"FINAL pathId: %@", self.pathId);
    self.parent = parent;
    // looking for children
    NSMutableArray *children_prop = [catDict objectForKey:@"children"];
    if (children_prop) {
        self.children = [[NSMutableArray alloc] init];
        for (NSDictionary *cat in children_prop) {
            HelpCategory *category = [[HelpCategory alloc] initWithDictionary:cat parent:self];
            [self.children addObject:category];
        }
    } else {
        self.children = nil;
    }
    
    return self;
}

@end
