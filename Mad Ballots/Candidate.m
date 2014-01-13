//
//  Candidate.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Candidate.h"

@implementation Candidate

@synthesize candidateId;
@synthesize contestantId;
@synthesize cardId;
@synthesize value;
@synthesize player;

+(RKObjectMapping*)getObjectMapping{
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Candidate class]];
    [playerMapping mapKeyPath:@"id" toAttribute:@"candidateId"];
    [playerMapping mapKeyPath:@"card_id" toAttribute:@"cardId"];
    [playerMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [playerMapping mapKeyPath:@"value" toAttribute:@"value"];
    [playerMapping mapKeyPath:@"player" toRelationship:@"player" withMapping:[Player getObjectMapping]];
    return playerMapping;
}



+(RKObjectMapping*)getSerializationMapping{
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[Candidate class]];
    [serializationMapping mapKeyPath:@"id" toAttribute:@"candidateId"];
    [serializationMapping mapKeyPath:@"card_id" toAttribute:@"cardId"];
    [serializationMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [serializationMapping mapKeyPath:@"value" toAttribute:@"value"];
    serializationMapping = [serializationMapping inverseMapping];
    serializationMapping.rootKeyPath = @"candidate";
    return serializationMapping;
}


@end
