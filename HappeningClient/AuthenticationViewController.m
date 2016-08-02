//
//  AuthenticationViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/31/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>
#import "HappeningsTableViewController.h"


@interface AuthenticationViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *loginOrSignUpSegmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextBox;
@property (strong, nonatomic) IBOutlet UITextField *emailTextBox;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (strong, nonatomic) IBOutlet UIButton *signUpOrLoginButton;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)controlIndexChanged:(UISegmentedControl *)sender {
    if ([_loginOrSignUpSegmentedControl selectedSegmentIndex] == 0) {
        [_usernameTextBox setEnabled:YES];
        [_usernameTextBox setAlpha:1.0];
        _signUpOrLoginButton.titleLabel.text = @"Sign Up";
    } else {
        [_usernameTextBox setEnabled:NO];
        [_usernameTextBox setAlpha:0.0];
        _signUpOrLoginButton.titleLabel.text = @"Login";
    }
}

#pragma mark - Network calls to API

- (void)createNewUser {
    
    // User info storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Keychain access for JWT and password
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    // Add password to keychain
    [keychain setString:_passwordTextBox.text forKey:@"password"];
    
    NSLog(@"%@", _usernameTextBox.text);
    
    NSDictionary *newUserInfo = @{@"user": @{@"username": _usernameTextBox.text, @"email": _emailTextBox.text, @"password": _passwordTextBox.text}};
    NSString *newUserAPIRoute = @"http://localhost:3000/users";
    NSString *newTokenRoute = @"http://localhost:3000/user_token";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:newUserAPIRoute parameters:newUserInfo progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response from server:\nEmail: %@\nid: %@\nusername: %@", responseObject[@"email"], responseObject[@"id"], responseObject[@"username"]);
        [defaults setInteger:[responseObject[@"id"] integerValue] forKey:@"id"];
        [defaults setObject:responseObject[@"username"] forKey:@"username"];
        [defaults setObject:responseObject[@"email"] forKey:@"email"];
        [defaults synchronize];
        
        NSDictionary *newTokenParams = @{@"auth": @{@"email": [defaults objectForKey:@"email"], @"password": [keychain stringForKey:@"password"]}};
        
        [manager POST:newTokenRoute parameters:newTokenParams progress:nil success:^(NSURLSessionDataTask *task, id tokenResponseObject) {
            
            NSLog(@"token: %@", tokenResponseObject[@"jwt"]);
            
            [keychain setString:tokenResponseObject[@"jwt"] forKey:@"token"];
            
            NSLog(@"password: %@\ntoken: %@\n", [keychain stringForKey:@"password"], [keychain stringForKey:@"token"]);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)authenticateExistingUser {
    // Keychain access for JWT and password
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    NSString *authenticateURL = @"http://localhost:3000/user_token";
    
    NSDictionary *newTokenParams = @{@"auth": @{@"email": _emailTextBox.text, @"password": _passwordTextBox.text}};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:authenticateURL parameters:newTokenParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"token: %@", responseObject[@"jwt"]);
        [keychain setString:responseObject[@"jwt"] forKey:@"token"];
        [(HappeningsTableViewController *)self.presentingViewController getNewHappeningsAndReloadView];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}
     
- (IBAction)authenticateButtonPressed:(UIButton *)sender {
    if ([_loginOrSignUpSegmentedControl selectedSegmentIndex ] == 0) {
        [self createNewUser];
    } else {
        [self authenticateExistingUser];
    }
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
