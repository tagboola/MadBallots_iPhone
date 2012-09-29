//
//  NSMutableArray+getCandidateValue.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+getCandidateValue.h"

@implementation NSMutableArray (getCandidateValue)

-(NSString*) getCandidateValue{
    Candidate *candidate = [self objectAtIndex:0];
    if(candidate.candidateGroup)
        return candidate.candidateGroup.value;
    if(self.count > 1)
        return [candidate.value uppercaseString];
    return candidate.value;
}

@end
