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
    NSString *createUserRequestURL = @"https://happening-api.herokuapp.com/users";
    NSDictionary *userInfo = @{@"user": @{ @"email": @"theanna@detroitlabs.com", @"password": @"password"}};
    NSDictionary *getTokenInfo = @{@"auth": @{ @"email": @"theanna@detroitlabs.com", @"password": @"password"}};
    NSString *getTokenURL = @"http://happening-api.herokuapp.com/user_token";
    // Set up session manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:createUserRequestURL parameters:userInfo progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        [manager POST:getTokenURL parameters:getTokenInfo progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary *tokenResponseDict = (NSDictionary *)responseObject;
            NSLog(@"Token response: %@", tokenResponseDict);
        } failure:^(NSURLSessionTask *task, id responseObject) {
            
        }];
        NSLog(@"Params: %@", userInfo.description);
        NSLog(@"%@", responseDict.description);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"Params: %@", userInfo.description);
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
    unsigned unitFlags = NSCalendarUnitYearForWeekOfYear | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendarFromDate components:unitFlags fromDate:_datePicker.date];
    components.timeZone = [NSTimeZone timeZoneWithName:@"US/Eastern"];
    NSLog(@"Components day of week: %ld", components.weekday);
    NSDate *dateFromComponents = [calendarFromDate dateFromComponents:components];
    NSLog(@"Date: %@", dateFromComponents);
    
}
- (IBAction)setStartDateButtonPressed:(UIButton *)sender {
    
}
- (IBAction)setEndDateButtonPressed:(UIButton *)sender {
    
}

@end
