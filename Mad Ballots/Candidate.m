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


+(RKObjectMapping*)getObjectMapping{
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Candidate class]];
    [playerMapping mapKeyPath:@"id" toAttribute:@"candidateId"];
    [playerMapping mapKeyPath:@"card_id" toAttribute:@"cardId"];
    [playerMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [playerMapping mapKeyPath:@"value" toAttribute:@"value"];    
    return playerMapping;
}


@end
