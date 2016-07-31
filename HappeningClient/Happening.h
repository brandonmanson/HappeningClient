//
//  Happening.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Happening : NSObject

@property (nonatomic) int happeningId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSMutableArray *days;

- (id)initWithName:(NSString *)name onDate:(NSDate *)startDate endingOn:(NSString *)endDate withId:(int)happeningId;
+ (id)initWithName:(NSString *)name onDate:(NSDate *)startDate endingOn:(NSString *)endDate withId:(int)happeningId;

@end
