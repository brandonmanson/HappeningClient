//
//  Day.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Day.h"

@implementation Day

- (id)initWithDate:(NSDate *)date andRemoteID:(int)remoteID {
    self = [super init];
    
    if (self) {
        _date = date;
        _remoteID = remoteID;
    }
    return self;
}

+ (id)initWithDate:(NSDate *)date andRemoteID:(int)remoteID {
    return [[super alloc] initWithDate:date andRemoteID:remoteID];
}

@end
