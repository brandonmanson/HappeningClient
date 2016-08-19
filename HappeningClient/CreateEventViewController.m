//
//  CreateEventViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "CreateEventViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface CreateEventViewController ()
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *startTimeTextField;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _eventNameTextField.borderStyle = UITextBorderStyleNone;
    _startTimeTextField.borderStyle = UITextBorderStyleNone;
    
    _startTimePicker = [[UIDatePicker alloc] init];
    _startTimePicker.datePickerMode = UIDatePickerModeTime;
    
    _startTimePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _startTimePickerToolbar.barStyle = UIBarStyleDefault;
    
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *startTimeDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateStartTimeTextField:)];
    
    [_startTimePickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, startTimeDoneButton, nil]];
    
    _startTimeTextField.inputAccessoryView = _startTimePickerToolbar;
    _startTimeTextField.inputView = _startTimePicker;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"day_id: %i", _dayID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateStartTimeTextField:(UIBarButtonItem *)doneButton {
    NSLog(@"_date: %@", _date.description);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName: @"US/Eastern"]];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitTimeZone) fromDate:_date];
    NSLog(@"comps: %@", comps.description);
    NSDateComponents *timeComps = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:_startTimePicker.date];
    [comps setHour:timeComps.hour];
    [comps setMinute:timeComps.minute];
    NSDate *dateFromComps = [calendar dateFromComponents:comps];
    NSLog(@"date from comps: %@", dateFromComps);
    _dateToPass = dateFromComps;
    NSLog(@"_dateToPass: %@", _dateToPass);
    _startTimeTextField.text = dateFromComps.description;
}

- (IBAction)addToItineraryButtonPressed:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    NSString *dateToPassToAPI = [formatter stringFromDate:_dateToPass];
    NSLog(@"date to pass: %@", dateToPassToAPI);
    
    NSNumber *dayID = [NSNumber numberWithInt:_dayID];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/events"];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    
    NSDictionary *params = @{@"event": @{@"name": _eventNameTextField.text,
                                         @"start_time": dateToPassToAPI,
                                         @"day_id": dayID}};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [manager POST:requestURL parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Event created");
        [_delegate updateEventList];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
