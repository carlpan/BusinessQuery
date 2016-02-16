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


- (id)initWithName:(NSString *)name;
+ (id)merchantInfoWithName:(NSString *)name;

@end
