//
//  Ballot.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ballot.h"

@implementation Ballot

@synthesize ballotId;
@synthesize ticketId;
@synthesize contestantId;
@synthesize candidateId;

+(RKObjectMapping*)getObjectMapping{
        RKObjectMapping *ballotMapping = [RKObjectMapping mappingForClass:[Ballot class]];
        [ballotMapping mapKeyPath:@"id" toAttribute:@"ballotId"];
        [ballotMapping mapKeyPath:@"ticket_id" toAttribute:@"ticketId"];
        [ballotMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
        [ballotMapping mapKeyPath:@"candidate_id" toAttribute:@"candidateId"];
        return ballotMapping;
}

@end
