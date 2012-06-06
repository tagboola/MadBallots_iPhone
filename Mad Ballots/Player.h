//
//  Player.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@class Facebook;

@interface Player : NSObject{
    NSString *playerId;
    NSString *username;
    NSString *email;
    NSString *name;
    NSString *password;
    NSString *passwordConfirmation;
    NSString *facebookId;
    NSString *persistenceToken;
}

@property (nonatomic,retain) NSString *playerId;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *passwordConfirmation;
@property (nonatomic,retain) NSString *facebookId;
@property (nonatomic,retain) NSString *persistenceToken;


+(RKObjectMapping*)getObjectMapping;



@end
