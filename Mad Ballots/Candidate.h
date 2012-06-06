//
//  Candidate.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface Candidate : NSObject{
    NSString *candidateId;
    NSString *contestantId;
    NSString *cardId;
    NSString *value;
}


@property (nonatomic, retain) NSString *candidateId;
@property (nonatomic, retain) NSString *contestantId;
@property (nonatomic, retain) NSString *cardId;
@property (nonatomic, retain) NSString *value;

+(RKObjectMapping*)getObjectMapping;

@end
