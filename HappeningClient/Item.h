//
//  Item.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *itemDescription;

- (id)initWithItemDescription:(NSString *)description;
+ (id)initWithItemDescription:(NSString *)description;

@end