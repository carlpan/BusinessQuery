//
//  ViewController.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/15/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

/**
 Paths and search terms for Yelp API
 */
static NSString * const kAPIHost = @"api.yelp.com";
static NSString * const kSearchPath = @"/v2/search/";
static NSString * const kSearchLimit = @"3";

@interface ViewController ()

@property (strong, nonatomic) NSArray *merchants;
@property (strong, nonatomic) NSDictionary *merchantDetails;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
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
        
        // Get "businesses" array containing requested nearby businesses
        //NSArray *businessArray = searchResponseJSON[@"businesses"];
        
        // continue with building the business dictionary containing required info to display to table view cell
        
    }];
    
    [task resume];
}


#pragma mark - UITableViewDataSource & UITableViewDelgate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];

    return cell;
}



#pragma mark - Yelp API Search Functionalities

/** 
 Builds request to hit the search endpoint with the given parameters.
 
 @param location specifies the city or neighborhoods of the search
 */
- (NSURLRequest *)_searchRequestWithLocation:(NSString *)location {
    NSDictionary *params = @{@"location": location, @"limit": kSearchLimit};
    
    return [AppDelegate requestWithHost:kAPIHost path:kSearchPath params:params];
}


@end
