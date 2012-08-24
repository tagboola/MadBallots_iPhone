//
//  Candidate.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "Player.h"
#import "CandidateGroup.h"

@interface Candidate : NSObject


@property (nonatomic, retain) NSString *candidateId;
@property (nonatomic, retain) NSString *contestantId;
@property (nonatomic, retain) NSString *cardId;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *candidateGroupId;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) CandidateGroup *candidateGroup;


+(RKObjectMapping*)getObjectMapping;
+(RKObjectMapping*)getSerializationMapping;

@end
