//
//  SearchTableTableViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SearchTableTableViewController : UITableViewController <UISearchResultsUpdating>

@property (strong, nonatomic) NSMutableArray *usersArray;

@end
