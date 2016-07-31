//
//  Item.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithItemDescription:(NSString *)description {
    self = [super init];
    
    if (self) {
        _itemDescription = description;
    }
    
    return self;
}

+ (id)initWithItemDescription:(NSString *)description {
    return [[super alloc] initWithItemDescription:description];
}

@end
