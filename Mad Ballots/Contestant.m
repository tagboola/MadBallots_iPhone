//
//  Contestant.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Contestant.h"

@implementation Contestant

@synthesize contestantId;
@synthesize gameId;
@synthesize playerId;
@synthesize game;
@synthesize card;
@synthesize round;
@synthesize status;
@synthesize gameOwner;
@synthesize currentRoundCount;
@synthesize player;
@synthesize score;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *contestantMapping = [RKObjectMapping mappingForClass:[Contestant class]];
    [contestantMapping mapKeyPath:@"id" toAttribute:@"contestantId"];
    [contestantMapping mapKeyPath:@"game_id" toAttribute:@"gameId"];
    [contestantMapping mapKeyPath:@"player_id" toAttribute:@"playerId"];
    [contestantMapping mapKeyPath:@"game" toRelationship:@"game" withMapping:[Game getObjectMapping]];
    [contestantMapping mapKeyPath:@"active_card" toRelationship:@"card" withMapping:[Card getObjectMapping]];
    [contestantMapping mapKeyPath:@"current_round" toRelationship:@"round" withMapping:[Round getObjectMapping]];
    [contestantMapping mapKeyPath:@"player" toRelationship:@"player" withMapping:[Player getObjectMapping]];
    [contestantMapping mapKeyPath:@"status" toAttribute:@"status"];
    [contestantMapping mapKeyPath:@"game_owner" toAttribute:@"gameOwner"];
    [contestantMapping mapKeyPath:@"current_round_count" toAttribute:@"currentRoundCount"];
    [contestantMapping mapKeyPath:@"score" toAttribute:@"score"];

    return contestantMapping;
}

+(RKObjectMapping*) getPostObjectMapping{
    RKObjectMapping *contestantMapping = [RKObjectMapping mappingForClass:[Contestant class]];
    [contestantMapping mapKeyPath:@"id" toAttribute:@"contestantId"];
    [contestantMapping mapKeyPath:@"game_id" toAttribute:@"gameId"];
    [contestantMapping mapKeyPath:@"player_id" toAttribute:@"playerId"];
    [contestantMapping mapKeyPath:@"status" toAttribute:@"status"];
    return contestantMapping;
    
}

-(NSString*) getGameStatus{
    if([status isEqualToString:@"0"])
        return [NSString stringWithFormat:@"You have received an invitation from %@", gameOwner];
    else if(card == nil || round == nil)
        return [NSString stringWithFormat:@"Waiting for %@ to start the game...", gameOwner];
    else if(![card isCardFilled])
        return @"Fill your card";
    else if(![round areCardsFilled])
        return @"Waiting for cards be filled...";
    else if(![card isVoteCast])
        return @"Cast your vote!";
    else if(![round areVotesCast])
        return @"Waiting for votes to be cast...";
    
    return @"";
}

-(BOOL) isActionNeeded{
    if([status isEqualToString:@"0"])
        return YES;
    else if(card == nil || round == nil)
        return NO;
    else if(![card isCardFilled])
        return YES;
    else if(![round areCardsFilled])
        return NO;
    else if(![card isVoteCast])
        return YES;
    else if(![round areVotesCast])
        return NO;
    
    return NO;    
}

-(BOOL) isInvitation{
    return [status isEqualToString:@"0"];
}

-(NSString*) getCategory{
    if(round == nil || round.category)
        return @"No Category";
    else
        return round.category;      
}

-(NSString*) getRoundDescription{
    if(round == nil)
        return [NSString stringWithFormat:@"Round 0 of %@",game.numberOfRounds];
    else
        return [NSString stringWithFormat:@"Round %@ of %@",currentRoundCount,game.numberOfRounds];
}

@end
