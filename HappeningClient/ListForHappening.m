//
//  ListForHappening.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListForHappening.h"

@implementation ListForHappening

- (id)initWithListName:(NSString *)name {
    self = [super init];
    
    if (self) {
        _name = name;
    }
    return self;
}

+ (id)initWithListName:(NSString *)name {
    return [[super alloc] initWithListName:name];
    
}

@end
