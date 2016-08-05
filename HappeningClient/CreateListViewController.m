//
//  CreateListViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "CreateListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface CreateListViewController ()
@property (strong, nonatomic) IBOutlet UITextField *listNameTextField;

@end

@implementation CreateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createEventButtonPressed:(UIButton *)sender {
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *requestURL = @"http://localhost:3000/lists";

    NSDictionary *newListParams = @{@"list": @{
                                            @"name": _listNameTextField.text,
                                            @"happening_id": [NSNumber numberWithInt:_happeningID]
                                            }
                                    };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [manager POST:requestURL parameters:newListParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"List created");
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
