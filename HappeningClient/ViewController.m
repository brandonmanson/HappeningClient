//
//  ViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/11/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//
// Helpers for date calculation and other things are available in the README for this repo
// https://github.com/brandonmanson/HappeningClient


#import "ViewController.h"
#import "HappeningClient-Swift.h"
#import <AFNetworking/AFNetworking.h>
#import "ISO8601DateFormatter.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController
NSString *token;

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameLabel.text = @"";
    HappeningJWTDecoder *decoder = [[HappeningJWTDecoder alloc] init];
    NSInteger userId = [decoder returnUserId:token];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)apiRequestButtonPressed:(UIButton *)sender {
    NSString *createUserRequestURL = @"http://localhost:3000/happenings";
//    NSDictionary *userInfo = @{@"user": @{ @"email": @"theanna@detroitlabs.com", @"password": @"password"}};
//    NSDictionary *getTokenInfo = @{@"auth": @{ @"email": @"theanna@detroitlabs.com", @"password": @"password"}};
//    NSString *getTokenURL = @"http://happening-api.herokuapp.com/user_token";
    // Set up session manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:createUserRequestURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        // Response from server
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        NSLog(@"%@", responseDict.description);
        
        // Parse the response and create a date object
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
//        NSString *startDate = [responseDict valueForKey:@"start_time"];
//        NSDate *dateFromResponse = [formatter dateFromString:startDate];
//        NSLog(@"Date: %@", dateFromResponse);
//        
//        // Convert date object into proper time zone
//        NSCalendar *outputCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//        [outputCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
//        unsigned unitFlags = NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
//        
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        [outputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
//        [outputFormatter setTimeStyle:NSDateFormatterLongStyle];
//        [outputFormatter setDateStyle:NSDateFormatterLongStyle];
//        
//        NSDateComponents *convertedDateComps = [outputCalendar components:unitFlags fromDate:dateFromResponse];
//        NSLog(@"Hour: %ld, Minute: %ld", (long)convertedDateComps.hour, (long)convertedDateComps.minute);
//        NSString *outputDateString = [outputFormatter stringFromDate:dateFromResponse];
//        NSLog(@"Converted date: %@", outputDateString);
        
        
//        [manager POST:getTokenURL parameters:getTokenInfo progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//            NSDictionary *tokenResponseDict = (NSDictionary *)responseObject;
//            NSLog(@"Token response: %@", tokenResponseDict);
//        } failure:^(NSURLSessionTask *task, id responseObject) {
//            
//        }];
//        NSLog(@"Params: %@", userInfo.description);
//        NSLog(@"%@", responseDict.description);
    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@"Params: %@", userInfo.description);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Receiving JSON Response from server" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
//    // Check header before setting it manually
//    NSLog(@"authorization header before setting: %@", [manager.requestSerializer valueForHTTPHeaderField:@"authorization"]);
//    
//    [manager.requestSerializer setValue:headerValue forHTTPHeaderField:@"authorization"];
//    
//    // Check header after setting it manually
//    NSLog(@"authorization header after setting: %@", [manager.requestSerializer valueForHTTPHeaderField:@"authorization"]);
//    
    
    // Make request
//    [manager.requestSerializer requestWithMethod:@"GET" URLString:requestURL parameters:nil error:nil];
    
}
- (IBAction)getEmailButtonPressed:(UIButton *)sender {
}
- (IBAction)checkDateButtonPressed:(UIButton *)sender {
    NSCalendar *calendarFromDate = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Calendar units to pull from date
    [calendarFromDate setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    unsigned unitFlags = NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSLog(@"Date: %@", _datePicker.date);
    NSDateComponents *components = [calendarFromDate components:unitFlags fromDate:_datePicker.date];
    NSDate *dateFromComponents = [calendarFromDate dateFromComponents:components];
    NSLog(@"Date from components: %@", dateFromComponents);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZ"];
    NSString *formattedDateString = [formatter stringFromDate:dateFromComponents];
    NSLog(@"Formatted date: %@", formattedDateString);
}
- (IBAction)setStartDateButtonPressed:(UIButton *)sender {
    
}
- (IBAction)setEndDateButtonPressed:(UIButton *)sender {
    
}

@end
