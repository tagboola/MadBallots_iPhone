//
//  MBAuthenticationInfo.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBAuthenticationInfo.h"
#import "RKObjectMapping.h"

@implementation MBAuthenticationInfo

@synthesize name, email, nickname, firstName, lastName, location, description, phone, urls;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *authInfoMapping = [RKObjectMapping mappingForClass:[MBAuthenticationInfo class]];
    
    [authInfoMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"email": @"email",
                                                          @"nickname": @"nickname",
                                                          @"first_name": @"firstName",
                                                          @"last_name": @"lastName",
                                                          @"location": @"location",
                                                          @"description": @"description",
                                                          @"phone": @"phone",
                                                          @"urls": @"urls"
                                                          }];
    
    
    /*[authInfoMapping mapKeyPath:@"name" toAttribute:@"name"];
    [authInfoMapping mapKeyPath:@"email" toAttribute:@"email"];
    [authInfoMapping mapKeyPath:@"nickname" toAttribute:@"nickname"];
    [authInfoMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
    [authInfoMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
    [authInfoMapping mapKeyPath:@"location" toAttribute:@"location"];
    [authInfoMapping mapKeyPath:@"description" toAttribute:@"description"];
    [authInfoMapping mapKeyPath:@"phone" toAttribute:@"phone"];
    [authInfoMapping mapKeyPath:@"urls" toAttribute:@"urls"];*/
    return authInfoMapping;
}


-(id)init{
    self = [super init];
    return self;
}

@end
