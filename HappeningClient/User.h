//
//  User.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/3/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *email;
@property (nonatomic) int userID;

-(id)initWithUsername:(NSString *)username andEmail:(NSString *)email withRemoteID:(int)remoteID;
+(id)initWithUsername:(NSString *)username andEmail:(NSString *)email withRemoteID:(int)remoteID;

@end
