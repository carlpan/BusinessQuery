//
//  ViewController.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/15/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MyCell.h"
#import "MerchantInfo.h"

/**
 Paths and search terms for Yelp API
 */
static NSString * const kAPIHost = @"api.yelp.com";
static NSString * const kSearchPath = @"/v2/search/";
//static NSString * const kSearchLimit = @"3";

@interface ViewController ()

/*
@property (strong, nonatomic) NSDictionary *merchantOneDetails;
@property (strong, nonatomic) NSDictionary *merchantTwoDetails;
@property (strong, nonatomic) NSDictionary *merchantThreeDetails;
*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self queryNearbyBusiness];
}

#pragma mark - Private methods for querying

- (void)queryNearbyBusiness {
    // Create a request object with search term location
    NSURLRequest *searchRequest = [self _searchRequestWithLocation:@"Chicago, IL"];
    
    // Instantiate a session object
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create a data task to perform data downloading
    NSURLSessionDataTask *task = [session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Check for network error
        if (error) {
            NSLog(@"Error: Couldn't finish request: %@", error);
            return;
        }
        
        // HTTP error
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSLog(@"Error: Got status code %ld", (long)httpResponse.statusCode);
            return;
        }
        
        // Fetch JSON response
        NSError *parseErr;
        NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
        if (!searchResponseJSON) {
            NSLog(@"Error: Couldn't parse response: %@", parseErr);
            return;
        }
        
        // On success
        // Get "businesses" array containing requested nearby businesses
        NSArray *businessArray = searchResponseJSON[@"businesses"];
        
        // Run on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // Initialized array of businesses dictionary
            self.merchants = [NSMutableArray array];
            
            // Loop through the 'businesses' array
            for (NSDictionary *merchantDictionary in businessArray) {
                // Create MerchantInfo object
                MerchantInfo *mInfo = [MerchantInfo merchantInfoWithName:[merchantDictionary objectForKey:@"name"]];
                // set merchant category
                mInfo.category = [merchantDictionary objectForKey:@"categories"][0][0];
                // set merchant open status
                if ([merchantDictionary objectForKey:@"is_closed"]) {
                    mInfo.openStatus = @"OPEN";
                } else {
                    mInfo.openStatus = @"CLOSED";
                }
                
                // add object to merchants array
                [self.merchants addObject:mInfo];
            }
            
            /*
            // fill in the details for three merchant dictionaries
            self.merchantOneDetails = businessArray[0];
            self.merchantTwoDetails = businessArray[1];
            self.merchantThreeDetails = businessArray[2];
            */
            
            // Fill tableview with data
            [self.tableView reloadData];
        });
        
    }];
    
    [task resume];
}


#pragma mark - UITableViewDataSource & UITableViewDelgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    // remove leading margin for tableview separator
    [cell setLayoutMargins:UIEdgeInsetsZero];

    // Customize cell with merchant information
    MerchantInfo *mInfo = [self.merchants objectAtIndex:indexPath.row];
    cell.merchantName.text = mInfo.name;
    cell.merchantCategory.text = mInfo.category;
    cell.openStatus.text = mInfo.openStatus;
    
    /*
    switch (indexPath.row) {
        case 0:
            cell.merchantName.text = [self.merchantOneDetails objectForKey:@"name"];
            cell.merchantCategory.text = [self.merchantOneDetails objectForKey:@"categories"][0][0];
            if ([self.merchantOneDetails objectForKey:@"is_closed"]) {
                cell.openStatus.text = @"OPEN";
            } else {
                cell.openStatus.text = @"CLOSED";
            }
            break;
        case 1:
            cell.merchantName.text = [self.merchantTwoDetails objectForKey:@"name"];
            cell.merchantCategory.text = [self.merchantTwoDetails objectForKey:@"categories"][0][0];
            if ([self.merchantTwoDetails objectForKey:@"is_closed"]) {
                cell.openStatus.text = @"OPEN";
            } else {
                cell.openStatus.text = @"CLOSED";
            }

            break;
        case 2:
            cell.merchantName.text = [self.merchantThreeDetails objectForKey:@"name"];
            cell.merchantCategory.text = [self.merchantThreeDetails objectForKey:@"categories"][0][0];
            if ([self.merchantThreeDetails objectForKey:@"is_closed"]) {
                cell.openStatus.text = @"OPEN";
            } else {
                cell.openStatus.text = @"CLOSED";
            }

            break;
            
        default:
            break;
    }
     */
     
    return cell;
}



#pragma mark - Yelp API Search Functionalities

/** 
 Builds request to hit the search endpoint with the given parameters.
 
 @param location specifies the city or neighborhoods of the search
 */
- (NSURLRequest *)_searchRequestWithLocation:(NSString *)location {
    //NSDictionary *params = @{@"location": location, @"limit": kSearchLimit};
    NSDictionary *params = @{@"location": location};

    return [AppDelegate requestWithHost:kAPIHost path:kSearchPath params:params];
}


@end
