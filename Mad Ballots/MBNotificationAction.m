//
//  MBNotificationAction.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNotificationAction.h"

@implementation MBNotificationAction

@synthesize actionObjects;

-(id)initWithActionObjects:(NSArray *)actionObjArray{
    if (self = [super init])
    {
        self.actionObjects = actionObjArray;
    }
    return self;
}

-(void)execute{}


-(RKObjectMappingResult *)mapResourceFromJsonString:(NSString *)jsonObjString
{
    NSString* MIMEType = @"application/json";
    NSError* error = nil;
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:MIMEType];
    id parsedData = [parser objectFromString:jsonObjString error:&error];
    if (parsedData == nil && error) {
        NSLog(@"error");
    }
    
    RKObjectMappingProvider* mappingProvider = [RKObjectManager sharedManager].mappingProvider;
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult* result = [mapper performMapping];
    return result;
}





@end
