//
//  UsersTableViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/15/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "UsersTableViewController.h"
#import "User.h"
#import "SearchResultsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface UsersTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) SearchResultsTableViewController *resultsTableController;

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateTable];
    [self.tableView reloadData];
    
    _resultsTableController = [[SearchResultsTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - API calls

- (void)getUsersForHappening {
    _usersInHappening = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    
    NSString *requestURL = [NSString stringWithFormat:@"http://localhost::3000/happenings/%i", _happeningID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        
        for (id key in response) {
            User *newUser = [[User alloc] initWithUsername:key[@"username"] andEmail:key[@"email"] withRemoteID:[key[@"id"] integerValue]];
            [_usersInHappening addObject:newUser];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)getAllUsers {
    _allUsers = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    
    NSString *requestURL = @"http:://localhost::3000/users";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        
        for (id key in response) {
            User *newUser = [[User alloc] initWithUsername:key[@"username"] andEmail:key[@"email"] withRemoteID:[key[@"id"] integerValue]];
            [_allUsers addObject:newUser];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error:: %@", error.localizedDescription);
    }];
}

- (void)populateTable {
    [self getUsersForHappening];
    [self getAllUsers];
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_usersInHappening count];
    } else {
        return [_allUsers count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    User *userInCell;
    
    if (indexPath.section == 0) {
        userInCell = [_usersInHappening objectAtIndex:indexPath.row];
    } else {
        userInCell = [_allUsers objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
