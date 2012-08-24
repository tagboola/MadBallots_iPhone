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
@synthesize candidateGroupId;
@synthesize player;
@synthesize candidateGroup;

+(RKObjectMapping*)getObjectMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Candidate class]];
    [mapping mapKeyPath:@"id" toAttribute:@"candidateId"];
    [mapping mapKeyPath:@"card_id" toAttribute:@"cardId"];
    [mapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [mapping mapKeyPath:@"value" toAttribute:@"value"];
    [mapping mapKeyPath:@"candidate_group_id" toAttribute:@"candidateGroupId"];
    [mapping mapKeyPath:@"player" toRelationship:@"player" withMapping:[Player getObjectMapping]];
    [mapping mapKeyPath:@"candidate_group" toRelationship:@"candidateGroup" withMapping:[CandidateGroup getObjectMapping]];
    return mapping;
}



+(RKObjectMapping*)getSerializationMapping{
    RKObjectMapping *serializationMapping = [RKObjectMapping mappingForClass:[Candidate class]];
    [serializationMapping mapKeyPath:@"id" toAttribute:@"candidateId"];
    [serializationMapping mapKeyPath:@"card_id" toAttribute:@"cardId"];
    [serializationMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [serializationMapping mapKeyPath:@"value" toAttribute:@"value"];
    [serializationMapping mapKeyPath:@"candidate_group_id" toAttribute:@"candidateGroupId"];
    serializationMapping = [serializationMapping inverseMapping];
    serializationMapping.rootKeyPath = @"candidate";
    return serializationMapping;
}


@end
