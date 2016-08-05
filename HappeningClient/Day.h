//
//  Day.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *events;
@property (nonatomic) int remoteID;

- (id)initWithDate:(NSDate *)date andRemoteID:(int)remoteID;
+ (id)initWithDate:(NSDate *)date andRemoteID:(int)remoteID;

@end
