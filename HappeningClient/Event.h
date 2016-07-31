//
//  Event.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSString *eventDescription;

- (id)initWithName:(NSString *)name beginningAt:(NSDate *)startTime withDescription:(NSString *)description;
+ (id)initWithName:(NSString *)name beginningAt:(NSDate *)startTime withDescription:(NSString *)description;

@end
