//
//  Contestant.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "Game.h"
#import "Round.h"
#import "Card.h"
#import "Player.h"



@interface Contestant : NSObject{
    NSString *contestantId;
    NSString *gameId;
    NSString *playerId;
    NSString *status;
    Game *game;
    Round *round;
    Card *card;
    Player *player;
    NSString *gameOwner;
    NSString *currentRoundCount;
    NSString *score;
}

@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *gameId;
@property (nonatomic,retain) NSString *playerId;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) Game *game;
@property (nonatomic,retain) Round *round;
@property (nonatomic,retain) Card *card;
@property (nonatomic,retain) Player *player;
@property (nonatomic,retain) NSString *gameOwner;
@property (nonatomic,retain) NSString *currentRoundCount;
@property (nonatomic,retain) NSString *score;




+(RKObjectMapping*) getObjectMapping;
+(RKObjectMapping*) getPostObjectMapping;
+(RKObjectMapping*) getSerializationMapping;


-(NSString*) getGameStatus;
-(BOOL) isActionNeeded;
-(BOOL) isInvitation;
-(BOOL) hasAcceptedInvite;
-(BOOL) hasRejectedInvite;
-(NSString*) getCategory;
-(NSString*) getRoundDescription;

@end
