//
//  MBAuthenticationCredentials.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBAuthenticationCredentials.h"
#import "RKObjectMapping.h"

@implementation MBAuthenticationCredentials

@synthesize token, secret, secretConfirmation;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *authCredentialsMapping = [RKObjectMapping mappingForClass:[MBAuthenticationCredentials class]];
    [authCredentialsMapping mapKeyPath:@"token" toAttribute:@"token"];
    [authCredentialsMapping mapKeyPath:@"secret" toAttribute:@"secret"];
    [authCredentialsMapping mapKeyPath:@"secret_confirmation" toAttribute:@"secretConfirmation"];
    return authCredentialsMapping;
}




@end
