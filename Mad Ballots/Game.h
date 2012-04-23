//
//  Game.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Round.h"
#import "RestKit.h"

@interface Game : NSObject{
    NSString *name;
    NSString *gameId;
    NSString *ownerId;
    NSString *numberOfRounds;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *gameId;
@property (nonatomic,retain) NSString *ownerId;
@property (nonatomic,retain) NSString *numberOfRounds;


+(RKObjectMapping*)getObjectMapping;


@end
