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

- (id)initWithDate:(NSDate *)date;
+ (id)initWithDate:(NSDate *)date;

@end
