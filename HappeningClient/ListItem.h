//
//  Item.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItem : NSObject

@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *name;

- (id)initWithItemDescription:(NSString *)description andName:(NSString *)name;
+ (id)initWithItemDescription:(NSString *)description andName:(NSString *)name;

@end
