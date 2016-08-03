//
//  DaysViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/3/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Happening.h"
#import "ListForHappening.h"
#import "Day.h"
#import "User.h"

@interface DaysViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) int happeningID;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *lists;
@property (strong, nonatomic) NSMutableArray *users;

@end
