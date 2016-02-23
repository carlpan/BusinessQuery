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
#import "WebDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

/**
 Paths and search terms for Yelp API
 */
static NSString * const kAPIHost = @"api.yelp.com";
static NSString * const kSearchPath = @"/v2/search/";
//static NSString * const kSearchLimit = @"3";

@interface ViewController () <CLLocationManagerDelegate>

// First search based on current location
@property (strong, nonatomic) CLLocationManager *locationManager;

// Current location tracker
@property (strong, nonatomic) CLLocation *currentLocation;

//@property (strong, nonatomic) NSURLRequest *urlRequest;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Start getting current location
    [self initializeLocationManager];
}

#pragma mark - Private methods

- (void)queryNearbyBusinessWithRequest:(NSURLRequest *)searchRequest {
    // Create a request object with search term location
    //NSURLRequest *searchRequest = [self _searchRequestWithLocation:@"Chicago, IL"];
    
    
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
                // get merchant thumbnail image url
                mInfo.thumbnail = [merchantDictionary objectForKey:@"image_url"];
                // get merchant url page info
                mInfo.url = [NSURL URLWithString:[merchantDictionary objectForKey:@"url"]];
                // Get merchant location
                mInfo.latitude = [merchantDictionary objectForKey:@"location"][@"coordinate"][@"latitude"];
                mInfo.longitude = [merchantDictionary objectForKey:@"location"][@"coordinate"][@"longitude"];
                
                // add object to merchants array
                [self.merchants addObject:mInfo];
            }
            
            // Merchants array filled, sort the array
            
            // Fill tableview with data
            [self.tableView reloadData];
        });
        
    }];
    
    [task resume];
}

- (void)initializeLocationManager {
    self.currentLocation = [[CLLocation alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // request permission from user
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (NSNumber *)getMerchantDistanceWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    CLLocationDegrees merchantLatitude = [latitude doubleValue];
    CLLocationDegrees merchantLogitude = [longitude doubleValue];
    CLLocation *merchantLocation = [[CLLocation alloc] initWithLatitude:merchantLatitude longitude:merchantLogitude];
    
    // Get distance in meters
    CLLocationDistance distance = [self.currentLocation distanceFromLocation:merchantLocation];
    
    // Convert to miles
    double distanceInMiles = distance * 0.00062137;
    
    // Convert double to NSNumber and return
    return [NSNumber numberWithDouble:distanceInMiles];
}

//- (NSMutableArray *)sortMerchantsWithArray:(NSMutableArray *)merchantArray {
//
//}


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
    
    // Calculate distance from merchant in miles
    NSNumber *distanceToMerchant = [self getMerchantDistanceWithLatitude:mInfo.latitude longitude:mInfo.longitude];
    cell.merchantDistance.text = [NSString stringWithFormat:@"%.1f miles away", [distanceToMerchant doubleValue]];
    
    // get image url
    if ([mInfo.thumbnail isKindOfClass:[NSString class]]) {
        NSData *imageData = [NSData dataWithContentsOfURL:mInfo.getThumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        cell.thumbnailImageView.image = image;
    }
     
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"preparing for segue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"showContent"]) {
        // Get index path for selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Retrieve corresponding merchant
        MerchantInfo *mInfo = [self.merchants objectAtIndex:indexPath.row];
        
        // Two ways to set destination
        // 1.
        //[segue.destinationViewController setDetailURL:mInfo.url];
        
        // 2.
        WebDetailViewController *wvc = (WebDetailViewController *)segue.destinationViewController;
        wvc.detailURL = mInfo.url;
    }
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row selected: %d", (int)indexPath.row);
    
    MerchantInfo *mInfo = [self.merchants objectAtIndex:indexPath.row];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:mInfo.url];
    
    // Put navigation logic
}
*/


#pragma mark - CLLocationManagerDelegate

// Can only getting locations from this method, no other method will get locations before this delegate method
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = locations.lastObject;
    
    //NSLog(@"Longitude: %f", self.currentLocation.coordinate.longitude);
    //NSLog(@"Latitude: %f", self.currentLocation.coordinate.latitude);
    // set url request
    NSURLRequest *request = [self _searchRequestWithCoordinates:self.currentLocation];
    [self queryNearbyBusinessWithRequest:request];
    
    [self.locationManager stopUpdatingLocation];
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

- (NSURLRequest *)_searchRequestWithCoordinates:(CLLocation *)location {
    NSString *locationCoordinates = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    //NSLog(@"%@", locationCoordinates);
    NSDictionary *params = @{@"ll": locationCoordinates};
    
    return [AppDelegate requestWithHost:kAPIHost path:kSearchPath params:params];
}


@end
