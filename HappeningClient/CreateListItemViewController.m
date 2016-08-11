//
//  CreateListItemViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "CreateListItemViewController.h"
#import "ListItem.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface CreateListItemViewController ()
@property (strong, nonatomic) IBOutlet UITextField *listItemNameTextField;

@end

@implementation CreateListItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToListButtonPressed:(UIButton *)sender {
    NSNumber *listID = [NSNumber numberWithInt:_listID];
    NSDictionary *newListItemParams = @{@"list_item": @{
                                                @"name": _listItemNameTextField.text,
                                                @"description": @"",
                                                @"list_id": listID
                                                }
                                        };
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/list_items"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager POST:requestURL parameters:newListItemParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"List item created!");
        [_delegate getListItemsAndUpdateList];
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
