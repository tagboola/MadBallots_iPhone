//
//  MBPlayerSession.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBPlayerSession.h"

@implementation MBPlayerSession

@synthesize persistenceToken;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *playerSessionMapping = [RKObjectMapping mappingForClass:[MBPlayerSession class]];
    [playerSessionMapping mapKeyPath:@"persistence_token" toAttribute:@"persistenceToken"];
    return playerSessionMapping;
}



@end
