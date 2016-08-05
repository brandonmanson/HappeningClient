//
//  EventsTableViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "Event.h"

@interface EventsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *events;
@property (nonatomic) int dayID;

@end
