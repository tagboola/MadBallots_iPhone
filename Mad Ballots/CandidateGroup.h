//
//  CandidateGroup.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface CandidateGroup : NSObject

@property (nonatomic,retain) NSString *candidateGroupId;
@property (nonatomic,retain) NSString *value;


+(RKObjectMapping*)getObjectMapping;


@end
