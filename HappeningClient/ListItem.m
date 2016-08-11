//
//  ListItem.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (id)initWithItemDescription:(NSString *)description andName:(NSString *)name{
    self = [super init];
    
    if (self) {
        _itemDescription = description;
        _name = name;
    }
    
    return self;
}

+ (id)initWithItemDescription:(NSString *)description andName:(NSString *)name{
    return [[super alloc] initWithItemDescription:description andName:name];
}

@end
