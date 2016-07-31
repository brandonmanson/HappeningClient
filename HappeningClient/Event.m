//
//  Event.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Event.h"

@implementation Event

- (id)initWithName:(NSString *)name beginningAt:(NSDate *)startTime withDescription:(NSString *)description {
    self = [super init];
    
    if (self) {
        _name = name;
        _startTime = startTime;
        _eventDescription = description;
    }
    return self;
}

+ (id)initWithName:(NSString *)name beginningAt:(NSDate *)startTime withDescription:(NSString *)description {
    return [[super alloc] initWithName:name beginningAt:startTime withDescription:description];
}

@end
