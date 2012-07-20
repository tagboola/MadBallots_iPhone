//
//  Ticket.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

@synthesize ticketId;
@synthesize contestantId;
@synthesize roundId;
@synthesize voteStatus;
@synthesize state;
@synthesize player;
@synthesize winners;
//

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Ticket class]];
    [objectMapping mapKeyPath:@"id" toAttribute:@"ticketId"];
    [objectMapping mapKeyPath:@"round_id" toAttribute:@"roundId"];
    [objectMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [objectMapping mapKeyPath:@"vote_status" toAttribute:@"voteStatus"];
    [objectMapping mapKeyPath:@"state" toAttribute:@"state"];
    [objectMapping mapKeyPath:@"player" toRelationship:@"player" withMapping:[Player getObjectMapping]];
    [objectMapping mapKeyPath:@"winner.candidate" toRelationship:@"winners" withMapping:[Candidate getObjectMapping]];

    return objectMapping;
}

@end
