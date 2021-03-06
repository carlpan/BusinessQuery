//
//  MerchantInfo.h
//  BusinessQuery
//
//  Created by Carl Pan on 2/16/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *openStatus;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *merchantDistance;
@property (strong, nonatomic) NSString *merchantID;


- (id)initWithName:(NSString *)name;
+ (id)merchantInfoWithName:(NSString *)name;

- (NSURL *)getThumbnailURL;

@end
