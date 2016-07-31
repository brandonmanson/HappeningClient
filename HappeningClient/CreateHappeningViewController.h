//
//  CreateHappeningViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol happeningTableViewDelegate <NSObject>

- (void)getNewHappeningsAndReloadView;

@end

@interface CreateHappeningViewController : UIViewController

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) UIDatePicker *endDatePicker;
@property (strong, nonatomic) UIToolbar *startDatePickerToolbar;
@property (strong, nonatomic) UIToolbar *endDatePickerToolbar;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) id<happeningTableViewDelegate>delegate;


@end
