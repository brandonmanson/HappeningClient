//
//  CreateEventViewController.h
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateEventListDelegate <NSObject>

- (void)updateEventList;

@end

@interface CreateEventViewController : UIViewController

@property (nonatomic) int dayID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIDatePicker *startTimePicker;
@property (strong, nonatomic) UIToolbar *startTimePickerToolbar;
@property (strong, nonatomic) NSDate *dateToPass;
@property (strong, nonatomic) id<UpdateEventListDelegate>delegate;

@end
