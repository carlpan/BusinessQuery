//
//  MerchantInfo.m
//  BusinessQuery
//
//  Created by Carl Pan on 2/16/16.
//  Copyright © 2016 Carl Pan. All rights reserved.
//

#import "MerchantInfo.h"

@implementation MerchantInfo

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.category = nil;
        self.openStatus = nil;
        self.thumbnail = nil;
    }
    
    return self;
}

+ (id)merchantInfoWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (NSURL *)getThumbnailURL {
    return [NSURL URLWithString:self.thumbnail];
}

@end
