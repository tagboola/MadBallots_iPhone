//
//  Card.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize cardId;
@synthesize roundId;
@synthesize state;
@synthesize voteStatus;
@synthesize cardStatus;
@synthesize contestantId;


+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Card class]];
    [objectMapping mapKeyPath:@"id" toAttribute:@"cardId"];
    [objectMapping mapKeyPath:@"round_id" toAttribute:@"roundId"];
    [objectMapping mapKeyPath:@"contestant_id" toAttribute:@"contestantId"];
    [objectMapping mapKeyPath:@"vote_status" toAttribute:@"voteStatus"];
    [objectMapping mapKeyPath:@"card_status" toAttribute:@"cardStatus"];
    [objectMapping mapKeyPath:@"contestant_id" toAttribute:@"contestntId"];
    return objectMapping;
}

-(BOOL) isCardFilled{
    return [cardStatus isEqualToString:@"1"];
}
-(BOOL) isVoteCast{
    return [cardStatus isEqualToString:@"1"];
}

@end
