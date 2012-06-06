//
//  Player.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize playerId;
@synthesize email;
@synthesize username;
@synthesize name;
@synthesize password;
@synthesize passwordConfirmation;
@synthesize facebookId;
@synthesize persistenceToken;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Player class]];
    [playerMapping mapKeyPath:@"id" toAttribute:@"playerId"];
    [playerMapping mapKeyPath:@"email" toAttribute:@"email"];
    [playerMapping mapKeyPath:@"username" toAttribute:@"username"];
    [playerMapping mapKeyPath:@"name" toAttribute:@"name"];
    [playerMapping mapKeyPath:@"password" toAttribute:@"password"];
    [playerMapping mapKeyPath:@"password_confirmation" toAttribute:@"passwordConfirmation"];
    [playerMapping mapKeyPath:@"persistence_token" toAttribute:@"persistenceToken"];

    return playerMapping;
}

@end
