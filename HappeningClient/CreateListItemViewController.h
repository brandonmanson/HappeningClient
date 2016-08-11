//
//  CreateListItemViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateListItemDelegate <NSObject>

- (void)getListItemsAndUpdateList;

@end

@interface CreateListItemViewController : UIViewController

@property (nonatomic) int listID;
@property (strong, nonatomic) id<CreateListItemDelegate>delegate;

@end
