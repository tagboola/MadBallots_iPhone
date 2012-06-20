//
//  Ticket.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "Player.h"

@interface Ticket : NSObject{
    NSString *ticketId;
    NSString *contestantId;
    NSString *roundId;
    NSString *state;
    NSString *voteStatus;
    Player *player;
}

@property (nonatomic,retain) NSString *ticketId;
@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *roundId;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *voteStatus;
@property (nonatomic,retain) Player *player;


+(RKObjectMapping*) getObjectMapping;

@end
