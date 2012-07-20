//
//  Game.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize name;
@synthesize gameId;
@synthesize ownerId; 
@synthesize numberOfRounds;

+(RKObjectMapping*) getObjectMapping{
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[Game class]];
    [gameMapping mapKeyPath:@"name" toAttribute:@"name"];
    [gameMapping mapKeyPath:@"id" toAttribute:@"gameId"];
    [gameMapping mapKeyPath:@"owner_id" toAttribute:@"ownerId"];
    [gameMapping mapKeyPath:@"num_rounds" toAttribute:@"numberOfRounds"];
    return gameMapping;
}


-(BOOL) iAmOwner{
    return [ownerId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY]];
}





@end
