//
//  PeopleTableViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleTableViewController : UITableViewController

@property (strong, nonatomic) UISearchController *peopleSearchController;
@property (strong, nonatomic) NSMutableArray *allUsers;
@property (strong, nonatomic) NSMutableArray *usersInHappening;

@end
