//
//  ListForHappening.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListForHappening : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic) int remoteID;

- (id)initWithListName:(NSString *)name andID:(int)remoteID;
+ (id)initWithListName:(NSString *)name andID:(int)remoteID;

@end
