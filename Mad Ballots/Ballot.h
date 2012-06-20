//
//  Ballot.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface Ballot : NSObject{
    NSString *ballotId;
    NSString *ticketId;
    NSString *contestantId;
    NSString *candidateId;
}
@property (nonatomic,retain) NSString *ballotId;
@property (nonatomic,retain) NSString *ticketId;
@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *candidateId;



+(RKObjectMapping*)getObjectMapping;

@end
