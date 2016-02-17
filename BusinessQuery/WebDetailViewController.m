//
//  WebDetailViewController.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/17/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "WebDetailViewController.h"

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.detailURL];    
    [self.webDetailView loadRequest:request];
}

@end
