//
//  ViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/11/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ViewController.h"
#import "HappeningClient-Swift.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameLabel.text = @"";
    HappeningJWTDecoder *decoder = [[HappeningJWTDecoder alloc] init];
    NSString *token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NjkyMTAxMzYsInN1YiI6MX0.FiFd_psphiHrHUzIflBradBJrp4qGP0YnpWJgN_6gdY";
    NSInteger userId = [decoder returnUserId:token];
    NSLog(@"User id: %lu", userId);
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)apiRequestButtonPressed:(UIButton *)sender {
    
    
    // Set up session manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:headerValue forHTTPHeaderField:@"authorization"];
//    [manager GET:requestURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSDictionary *responseDict = (NSDictionary *)responseObject;
//        NSLog(@"%@", responseDict.description);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Receiving JSON Response from server" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }];
    
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

@end
