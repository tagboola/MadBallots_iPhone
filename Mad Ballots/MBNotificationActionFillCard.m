//
//  MBNotificationActionFillCard.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNotificationActionFillCard.h"
#import "CardViewController.h"

@implementation MBNotificationActionFillCard


-(void)execute{
    
    if([AppDelegate currentPlayer].playerId){
        
        NSString *contestantsPath = [NSString stringWithFormat:@"players/%@/contestants.json",[AppDelegate currentPlayer].playerId];
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:contestantsPath usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *objects) {
                
                Game *targetGame = NULL;
                Contestant *targetContestant = NULL;
                
                //Get the "target game"
                if (self.actionObjects.count > 0){
                    RKObjectMappingResult *gameObj = [self mapResourceFromJsonString:[self.actionObjects objectAtIndex:0]];
                    if (gameObj){
                        targetGame = [gameObj asObject];
                    }
                }
                
                if (targetGame){
                    
                    NSInteger targetContestantIndex = [objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        if ( ([obj isKindOfClass:[Contestant class]]) && ([[(Contestant *)obj gameId] isEqualToString:[targetGame gameId]]) ){
                            *stop = YES;
                            return YES;
                        }
                        return NO;
                    }];
                    targetContestant = [objects objectAtIndex:targetContestantIndex];
                    
                    if (targetContestant){
                        
                        UINavigationController *rootNavController = [[AppDelegate getInstance] rootNavController];
                        GamesViewController *gvc = [[rootNavController viewControllers] objectAtIndex:0];
                        
                        //Now create the view controller stack for display of the "target" action
                        //2) Conifgure the "target" game controller by loading the gameViewController from the storyboard and setting the "contestant" to the passed in contestant invitation
                        //GameViewController *targetGameViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"gameViewController"];
                        GameViewController *targetGameViewController = [[GameViewController alloc] initWithNibName:@"MBGameView" bundle:nil];
                        targetGameViewController.contestant = targetContestant;
                        
                        //3) Configure the "action" controller for the target game screen
                        //CardViewController *cardViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"cardViewController"];
                        CardViewController *cardViewController = [[CardViewController alloc] initWithNibName:@"CardView" bundle:nil];
                        cardViewController.cardId = targetContestant.card.cardId;
                        cardViewController.category = targetContestant.round.category;
                        
                        
                        //Set the view controller stack on the nav controller
                        [rootNavController setViewControllers:[NSArray arrayWithObjects:gvc, targetGameViewController, cardViewController, nil] animated:YES];
                        
                    }
                    
                }
                
            };
            
            loader.onDidFailWithError = ^(NSError *error){
                NSLog(@"Error loading contestant:%@",[error localizedDescription]);
            };
            
        }];
    }
    
}





@end
