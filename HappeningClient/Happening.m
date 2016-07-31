//
//  Happening.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Happening.h"

@implementation Happening

- (id)initWithName:(NSString *)name onDate:(NSDate *)startDate endingOn:(NSDate *)endDate withId:(int)happeningId {
    self = [super init];
    
    if (self) {
        _happeningId = happeningId;
        _name = name;
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

+ (id)initWithName:(NSString *)name onDate:(NSDate *)startDate endingOn:(NSString *)endDate withId:(int)happeningId {
    return [[super alloc] initWithName:name onDate:startDate endingOn:endDate withId:happeningId];
}

@end
