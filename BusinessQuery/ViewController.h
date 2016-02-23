//
//  ViewController.h
//  BusinessQuery
//
//  Created by Carl Pan on 2/15/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

// property contains array of dictionaries (each dictionary represents a yelp business)
@property (strong, nonatomic) NSMutableArray *merchants;

//- (void)queryNearbyBusiness;

@end

