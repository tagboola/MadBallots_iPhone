//
//  Card.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface Card : NSObject{
    NSString *cardId;
    NSString *roundId;
    NSString *contestantId;
    NSString *voteStatus;
    NSString *cardStatus;
    NSString *state;
}

@property (nonatomic,retain) NSString *cardId;
@property (nonatomic,retain) NSString *roundId;
@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *voteStatus;
@property (nonatomic,retain) NSString *cardStatus;
@property (nonatomic,retain) NSString *state;

+(RKObjectMapping*) getObjectMapping;

-(BOOL) isCardFilled;
-(BOOL) isVoteCast;


@end
