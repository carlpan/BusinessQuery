//
//  MapViewController.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/24/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "MapViewController.h"
#import "MerchantInfo.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) MKPointAnnotation *currentAnno;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add map view
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    
    // Add a bar button item to go back
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(listButtonClicked:)];
    self.navigationItem.rightBarButtonItem = listButton;
    [listButton setTintColor:[UIColor whiteColor]];
    
    // Style navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:33.0/255.0
                                                                           green:180.0/255.0
                                                                            blue:1.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Location stuff

    self.mapView.showsUserLocation = YES;
    [self initializeLocationManager];
    [self addAnnotations];
    //[self centerMap:[self.locations objectAtIndex:0]];
}

- (IBAction)listButtonClicked:(id)sender {
    [self.locationManager stopUpdatingLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)addAnnotations {
    // Add merchants annotations
    for (MerchantInfo *mInfo in self.merchantObjects) {
        MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake([mInfo.latitude doubleValue], [mInfo.longitude doubleValue]);
        anno.title = mInfo.name;
        [self.mapView addAnnotation:anno];
    }
}

- (void)centerMap:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000);
    MKCoordinateRegion adjusted = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjusted animated:YES];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = locations.lastObject;
    
    [self centerMap:self.currentLocation];
}



@end
