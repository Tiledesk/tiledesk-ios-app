//
//  HelpCategory.h

#import <Foundation/Foundation.h>

@interface HelpCategory : NSObject

@property(strong, nonatomic) NSDictionary *langs;
@property(strong, nonatomic) NSString *categoryId; // refactor > categoryId
@property(strong, nonatomic) NSMutableArray *children;
@property(strong, nonatomic) HelpCategory *parent;

@property(strong, nonatomic) NSString *nameInCurrentLocale;
@property(strong, nonatomic) NSString *imageName;
@property(strong, nonatomic) NSString *pathId;

- (id)initWithDictionary:(NSDictionary *)catDict parent:(HelpCategory *)parent;

@end
