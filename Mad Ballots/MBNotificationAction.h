//
//  MBNotificationAction.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNotificationActionHandler.h"
#import "AppDelegate.h"
#import "Contestant.h"
#import "Game.h"
#import "GameViewController.h"
#import "GamesViewController.h"

@interface MBNotificationAction : NSObject <MBNotificationActionHandler> 

-(RKObjectMappingResult *)mapResourceFromJsonString:(NSString *)jsonObjString;

@end
