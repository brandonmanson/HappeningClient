//
//  ListTableViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListForHappening.h"
#import "CreateListItemViewController.h"
#import "ListItem.h"

@interface ListTableViewController : UITableViewController <CreateListItemDelegate>

@property (strong, nonatomic) NSMutableArray *listItems;
@property (nonatomic) int listID;

@end
