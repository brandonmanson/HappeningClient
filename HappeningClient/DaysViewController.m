//
//  DaysViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/3/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "DaysViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface DaysViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *daysOrListsSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _days = [[NSMutableArray alloc] init];
    _users = [[NSMutableArray alloc] init];
    _lists = [[NSMutableArray alloc] init];
    [self getDaysForHappening:_happeningID];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Requests

- (void)getDaysForHappening:(int)happeningID {
    _days = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *getDaysURL = [NSString stringWithFormat:@"http://localhost:3000/days?happening_id=%i", happeningID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager GET:getDaysURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"response object: %@", response);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        for (id key in response) {
            NSDate *dateFromDictionary = [formatter dateFromString:key[@"date"]];
            Day *newDay = [[Day alloc] initWithDate:dateFromDictionary];
            [_days addObject:newDay];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 0) {
        Day *dayInCell = [_days objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *dateToDisplay = [formatter stringFromDate:dayInCell.date];
        cell.textLabel.text = dateToDisplay;
    } else if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 1) {
        ListForHappening *listInCell = [_lists objectAtIndex:indexPath.row];
        cell.textLabel.text = listInCell.name;
    } else {
        User *userInCell = [_users objectAtIndex:indexPath.row];
        cell.textLabel.text = userInCell.username;
    }
    return cell;
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
