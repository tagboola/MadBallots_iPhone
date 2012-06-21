//
//  Round.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Round.h"

@implementation Round

@synthesize roundId;
@synthesize category;
@synthesize gameId;
@synthesize state;
@synthesize voteStatus;
@synthesize cardStatus;


+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *roundMapping = [RKObjectMapping mappingForClass:[Round class]];
    [roundMapping mapKeyPath:@"id" toAttribute:@"roundId"];
    [roundMapping mapKeyPath:@"category" toAttribute:@"category"];
    [roundMapping mapKeyPath:@"game_id" toAttribute:@"gameId"];
    [roundMapping mapKeyPath:@"state" toAttribute:@"state"];
    [roundMapping mapKeyPath:@"vote_status" toAttribute:@"voteStatus"];
    [roundMapping mapKeyPath:@"card_status" toAttribute:@"cardStatus"];
    return roundMapping;
}

-(BOOL) areCardsFilled{
    return [cardStatus isEqualToString:@"1"];
    
}
-(BOOL) areVotesCast{
    return [voteStatus isEqualToString:@"1"];
}

-(BOOL) isRoundOver{
    return [self areCardsFilled] && [self areVotesCast];
}

@end
