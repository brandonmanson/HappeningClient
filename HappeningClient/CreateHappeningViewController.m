//
//  CreateHappeningViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "CreateHappeningViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>

@interface CreateHappeningViewController ()
@property (strong, nonatomic) IBOutlet UITextField *happeningNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *startDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *endDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;

@end

@implementation CreateHappeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterLongStyle];
    
    _startDatePicker = [[UIDatePicker alloc] init];
    _startDatePicker.datePickerMode = UIDatePickerModeDate;
    
    _endDatePicker = [[UIDatePicker alloc] init];
    _endDatePicker.datePickerMode = UIDatePickerModeDate;
    
    _startDatePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _startDatePickerToolbar.barStyle = UIBarStyleDefault;
    
    _endDatePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _endDatePickerToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *startDateDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateStartDateTextField:)];
    UIBarButtonItem *endDateDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateEndDateTextField:)];
    
    [_startDatePickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, startDateDoneButton, nil]];
    [_endDatePickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, endDateDoneButton, nil]];
    
    _startDateTextField.inputAccessoryView = _startDatePickerToolbar;
    _startDateTextField.inputView = _startDatePicker;
    
    _endDateTextField.inputAccessoryView = _endDatePickerToolbar;
    _endDateTextField.inputView = _endDatePicker;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateStartDateTextField:(UIBarButtonItem *)doneButton {
    _startDateTextField.text = [_formatter stringFromDate:_startDatePicker.date];
    _startDate = _startDatePicker.date;
    [self.view endEditing:YES];
}

- (void)updateEndDateTextField:(UIBarButtonItem *)doneButton {
    _endDateTextField.text = [_formatter stringFromDate:_endDatePicker.date];
    _endDate = _endDatePicker.date;
    [self.view endEditing:YES];
}

- (void)generateDatesBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    _dates = [[NSMutableArray alloc] init];
    [_dates addObject:_startDate];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *numberOfDays = [calendar components:(NSCalendarUnitDay)
                                                 fromDate:startDate
                                                   toDate:endDate
                                                  options:kNilOptions];
    int i = 1;
    
    while (i < numberOfDays.day) {
        NSDateComponents *dayInHappeningComps = [[NSDateComponents alloc] init];
        [dayInHappeningComps setDay:i];
        NSDate *dayInHappening = [calendar dateByAddingComponents:dayInHappeningComps
                                                           toDate:startDate
                                                          options:kNilOptions];
        [_dates addObject:dayInHappening];
        i++;
    }
    [_dates addObject:endDate];
    NSLog(@"Dates: %@", _dates.description);
}

- (void)createHappeningAndDatesWithData:(NSDictionary *)happeningData {
    NSString *createHappeningAPIRoute = @"http://localhost:3000/happenings";
    
    NSString *createDayAPIRoute = @"http://localhost:3000/days";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:createHappeningAPIRoute parameters:happeningData progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *happeningResponseObject = (NSDictionary *)responseObject;
        NSLog(@"Happening created! %@", happeningResponseObject.description);
        id happeningId = [happeningResponseObject objectForKey:@"id"];
        
        for (NSDate *date in _dates) {
            NSLog(@"in for loop");
            NSString *dateString = [formatter stringFromDate:date];
            NSDictionary *newDayObjectData = @{@"day": @{@"date": dateString, @"happening_id": happeningId}};
            [manager POST:createDayAPIRoute parameters:newDayObjectData progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary *response = (NSDictionary *)responseObject;
                NSLog(@"Day created! %@", response.description);
            } failure:^(NSURLSessionTask *task, NSError *error) {
                NSLog(@"Day not created. Error: %@", error.localizedDescription);
            }];
        }
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"Happening not created. Error: %@", error.localizedDescription);
    }];
}

- (IBAction)createHappeningButtonPressed:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *startDate = [formatter stringFromDate:_startDate];
    NSString *endDate = [formatter stringFromDate:_endDate];
    NSDictionary *happeningData = @{@"happening": @{@"name": _happeningNameTextField.text, @"start_date": startDate, @"end_date": endDate}};
    [self generateDatesBetweenStartDate:_startDate andEndDate:_endDate];
    [self createHappeningAndDatesWithData:happeningData];
    
}

@end
