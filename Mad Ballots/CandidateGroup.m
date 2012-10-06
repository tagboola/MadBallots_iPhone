//
//  CandidateGroup.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CandidateGroup.h"

@implementation CandidateGroup 

@synthesize candidateGroupId;
@synthesize value;


+(RKObjectMapping*)getObjectMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[CandidateGroup class]];
    [mapping mapKeyPath:@"id" toAttribute:@"candidateGroupId"];
    [mapping mapKeyPath:@"value" toAttribute:@"value"];
    return mapping;
}


@end
