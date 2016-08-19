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
#import "CreateListViewController.h"
#import "EventsTableViewController.h"
#import "Day.h"
#import "ListTableViewController.h"
#import "UsersTableViewController.h"

@interface DaysViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *daysOrListsSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _daysOrListsSegmentedControl.tintColor = [UIColor redColor];
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
            int idFromDictionary = [key[@"id"] integerValue];
            Day *newDay = [[Day alloc] initWithDate:dateFromDictionary andRemoteID:idFromDictionary];
            [_days addObject:newDay];
            NSLog(@"%@", _days.description);
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)getListsForHappening:(int)happeningID {
    _lists = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *getListsURL = [NSString stringWithFormat:@"http://localhost:3000/lists?happening_id=%i", happeningID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager GET:getListsURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        for (id key in response) {
            int listID = [key[@"id"] integerValue];
            ListForHappening *newList = [[ListForHappening alloc] initWithListName:key[@"name"] andID:listID];
            [_lists addObject:newList];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
}

- (void)getPeopleParticipatingInHappening:(int)happeningID {
    _users = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *getUsersURL = [NSString stringWithFormat:@"http://localhost:3000/happenings/%i", happeningID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager GET:getUsersURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSLog(@"%@", response);
        for (id key in response) {
            int userID = [key[@"id"] integerValue];
            User *newUser = [[User alloc] initWithUsername:key[@"username"] andEmail:key[@"email"] withRemoteID:userID];
            [_users addObject:newUser];
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
    if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 0) {
        return [_days count];
    } else if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 1) {
        return [_lists count];
    } else {
        return [_users count];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 0) {
        
        [self performSegueWithIdentifier:@"showEventsSegue" sender:indexPath];
        
    } else if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 1) {
        
        [self performSegueWithIdentifier:@"showListItemsSegue" sender:indexPath];
    
    }
}

#pragma mark - Segment Control

- (IBAction)segmentControlIndexChanged:(UISegmentedControl *)sender {
    if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 0) {
        [self getDaysForHappening:_happeningID];
    } else if ([_daysOrListsSegmentedControl selectedSegmentIndex] == 1) {
        [self getListsForHappening:_happeningID];
    } else {
        [self getPeopleParticipatingInHappening:_happeningID];
    }

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = sender;
    if ([segue.identifier isEqualToString:@"createNewListSegue"]) {
        CreateListViewController *vc = [segue destinationViewController];
        vc.happeningID = _happeningID;
    } else if ([segue.identifier isEqualToString:@"showEventsSegue"]) {
        Day *selectedDay = [_days objectAtIndex:indexPath.row];
        EventsTableViewController *vc = [segue destinationViewController];
        vc.date = selectedDay.date;
        vc.dayID = selectedDay.remoteID;
    } else if ([segue.identifier isEqualToString:@"showListItemsSegue"]) {
        ListForHappening *selectedList = [_lists objectAtIndex:indexPath.row];
        ListTableViewController *vc = [segue destinationViewController];
        vc.listID = selectedList.remoteID;
    } else if ([segue.identifier isEqualToString:@"goToUsersTableViewController"]) {
        UsersTableViewController *vc = [segue destinationViewController];
        vc.happeningID = _happeningID;
    }
}

@end
