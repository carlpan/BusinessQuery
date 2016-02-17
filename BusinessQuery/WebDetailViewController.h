//
//  WebDetailViewController.h
//  BusinessQuery
//
//  Created by Carl Pan on 2/17/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebDetailViewController : UIViewController

@property (strong, nonatomic) NSURL *detailURL;

@property (weak, nonatomic) IBOutlet UIWebView *webDetailView;

@end
