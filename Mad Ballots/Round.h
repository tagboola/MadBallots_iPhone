//
//  Round.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface Round : NSObject{
    NSString *roundId;
    NSString *category;
    NSString *gameId;
    NSString *voteStatus;
    NSString *cardStatus;
    NSString *state;
}

@property (nonatomic,retain) NSString *roundId;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *gameId;
@property (nonatomic,retain) NSString *voteStatus;
@property (nonatomic,retain) NSString *cardStatus;
@property (nonatomic,retain) NSString *state;


+(RKObjectMapping*) getObjectMapping;

-(BOOL) areCardsFilled;
-(BOOL) areVotesCast;

@end
