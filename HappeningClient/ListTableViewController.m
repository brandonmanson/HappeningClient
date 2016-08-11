//
//  ListTableViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 8/4/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "ListTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SimpleKeychain/SimpleKeychain.h>

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getListItemsAndUpdateList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Method

- (void)getListItemsAndUpdateList {
    _listItems = [[NSMutableArray alloc] init];
    
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/list_items?list_id=%i", _listID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        for (id key in response) {
            ListItem *newListItem = [[ListItem alloc] initWithItemDescription:key[@"description"] andName:key[@"name"]];
            [_listItems addObject:newListItem];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listItemCell" forIndexPath:indexPath];
    
    ListItem *itemInCell = [_listItems objectAtIndex:indexPath.row];
    cell.textLabel.text = itemInCell.name;
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"createListItemSegue"]) {
        CreateListItemViewController *vc = [segue destinationViewController];
        vc.listID = _listID;
        [vc setDelegate:self];
    }
}


@end
