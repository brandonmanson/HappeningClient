//
//  HappeningsTableViewController.m
//  HappeningClient
//
//  Created by Brandon Manson on 7/27/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "HappeningsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Happening.h"
#import "DaysViewController.h"
#import "CreateHappeningViewController.h"
#import "AuthenticationViewController.h"
#import <SimpleKeychain/SimpleKeychain.h>
#import "HappeningClient-Swift.h"

@interface HappeningsTableViewController ()

@end

@implementation HappeningsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewHappeningsAndReloadView];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    HappeningJWTDecoder *decoder = [[HappeningJWTDecoder alloc] init];
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSString *token = [keychain stringForKey:@"token"];
    
    if (token == nil || [decoder isExpired:token]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AuthenticationViewController *authVC = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticationViewController"];
        authVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self setDefinesPresentationContext:YES];
        [self presentViewController:authVC animated:YES completion:nil];
    }
}

#pragma mark - Delegate Methods

- (void)getNewHappeningsAndReloadView {
    NSLog(@"Method called");
    _happenings = [[NSMutableArray alloc] init];
    A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [keychain stringForKey:@"token"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    NSString *getHappeningsURL = [NSString stringWithFormat:@"http://localhost:3000/users?id=%@", [defaults stringForKey:@"id"]];
    [manager GET:getHappeningsURL parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: \n%@", responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        for (id key in response) {
            Happening *newHappening = [self createNewHappeningFromDictionary:key];
            NSLog(@"happening name: %@", newHappening.name);
            [_happenings addObject:newHappening];
        }
        [self.tableView reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

#pragma mark - Create new Happening Objects

-(Happening *)createNewHappeningFromDictionary:(NSDictionary *)dataFromAPIResponse {
    Happening *newHappening = [[Happening alloc] init];
    newHappening.happeningId = [dataFromAPIResponse[@"id"] intValue];
    newHappening.name = dataFromAPIResponse[@"name"];
    newHappening.startDate = [self generateDateFromString:dataFromAPIResponse[@"start_date"]];
    newHappening.endDate = [self generateDateFromString:dataFromAPIResponse[@"end_date"]];
    NSLog(@"New Happening: %@", newHappening.description);
    return newHappening;
}

- (NSDate *)generateDateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateToReturn = [formatter dateFromString:dateString];
    NSLog(@"Date: %@", dateToReturn);
    return dateToReturn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_happenings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"happeningCell" forIndexPath:indexPath];
    Happening *happeningInCell = [_happenings objectAtIndex:indexPath.row];
    NSLog(@"%@", happeningInCell.name);
    cell.textLabel.text = happeningInCell.name;
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"createHappeningSegue"]) {
        CreateHappeningViewController *vc = [segue destinationViewController];
        [vc setDelegate:self];
    } else {        
        DaysViewController *vc = [segue destinationViewController];
        Happening *selectedHappening = [_happenings objectAtIndex:indexPath.row];
        NSLog(@"selected Happening: %@", selectedHappening);
        vc.happeningID = selectedHappening.happeningId;
    }
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}


@end
