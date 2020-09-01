//
//  TiledeskContactsSynchronizer.h
//  tiledesk
//
//  Created by Andrea Sponziello on 31/08/2020.
//  Copyright © 2020 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiledeskContactsSynchronizer : NSObject

@property (strong, nonatomic) NSString *token;

-(id _Nonnull )initWithToken:(NSString *_Nonnull)token; // user:(ChatUser *_Nonnull)user;
-(void)synch;

@end

NS_ASSUME_NONNULL_END
