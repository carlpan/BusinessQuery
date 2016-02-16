//
//  AppDelegate.h
//  BusinessQuery
//
//  Created by Carl Pan on 2/15/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


/**
 @param host The domain host
 @param path The path on the domain host
 @param params The query parameters
 @return Builds a NSURLRequest with all the OAuth headers field set with the host, path, and query parameters given to it.
 */
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end

