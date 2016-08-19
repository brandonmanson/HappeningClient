//
//  UsersTableViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/15/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *usersInHappening;
@property (strong, nonatomic) NSMutableArray *allUsers;
@property (nonatomic) int happeningID;

@end
