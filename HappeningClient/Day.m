//
//  Day.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Day.h"

@implementation Day

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    
    if (self) {
        _date = date;
    }
    return self;
}

+ (id)initWithDate:(NSDate *)date {
    return [[super alloc] initWithDate:date];
}

@end
