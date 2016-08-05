//
//  User.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/3/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithUsername:(NSString *)username andEmail:(NSString *)email withRemoteID:(int)remoteID {
    self = [super init];
    
    if (self) {
        _username = username;
        _email = email;
        _userID = remoteID;
    }
    return self;
}

+(id)initWithUsername:(NSString *)username andEmail:(NSString *)email withRemoteID:(int)remoteID {
    return [[super alloc] initWithUsername:username andEmail:email withRemoteID:remoteID];
}

@end
