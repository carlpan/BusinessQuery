//
//  AppDelegate.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/15/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "AppDelegate.h"
#import <TDOAuth/TDOAuth.h>


/**
 OAuth credentials for Yelp API
 */
static NSString * const kConsumerKey = @"6GzQoclYOQO64IxfdDbLIg";
static NSString * const kConsumerSecret = @"jIdJq3f8OQBttyn-jXItE6Zj4iQ";
static NSString * const kToken = @"8fSKYgQ9K7s2sYF4D4LyoTMgod3ue8uo";
static NSString * const kTokenSecret = @"Zdj2XM83GDzA15QcLwJVSvpHrVc";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Declare a shared NSURLCache
    // with 2mb of memory and 20mb of disk space
    /*
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:500 * 1024 * 1024
                                                            diskCapacity:500 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
     */
    
    //NSLog(@"DiskCache: %@ of %@", @([[NSURLCache sharedURLCache] currentDiskUsage]), @([[NSURLCache sharedURLCache] diskCapacity]));
    //NSLog(@"MemoryCache: %@ of %@", @([[NSURLCache sharedURLCache] currentMemoryUsage]), @([[NSURLCache sharedURLCache] memoryCapacity]));
    
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    UINavigationBar *navBar = navController.navigationBar;
    navBar.barStyle = UIBarStyleBlackOpaque;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Class method implementation

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
    return [TDOAuth URLRequestForPath:path
                        GETParameters:params
                               scheme:@"https"
                                 host:host
                          consumerKey:kConsumerKey
                       consumerSecret:kConsumerSecret
                          accessToken:kToken
                          tokenSecret:kTokenSecret];
}



@end
