//
//  MBNotificationActionRSVP.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNotificationActionRSVP.h"


@implementation MBNotificationActionRSVP


-(void)execute{
    
    Contestant *targetContestant = NULL;
    UINavigationController *rootNavController = [[AppDelegate getInstance] rootNavController];
    
    if (self.actionObjects.count > 0){
        RKObjectMappingResult *contestantObj = [self mapResourceFromJsonString:[self.actionObjects objectAtIndex:0]];
        if (contestantObj){
            targetContestant = [contestantObj asObject];
        }
    }
    
    
    //Now create the view controller stack for display of the "target" action
    
    //1) Get the gamesViewController reference from the Nav Controller
    GamesViewController *gvc = [[rootNavController viewControllers] objectAtIndex:0];
    
    //2) Conifgure the "target" game controller by loading the gameViewController from the storyboard and setting the "contestant" to the passed in contestant invitation
    GameViewController *targetGameViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"gameViewController"];
    targetGameViewController.contestant = targetContestant; 
    
    //Set the view controller stack on the nav controller
    [rootNavController setViewControllers:[NSArray arrayWithObjects:gvc, targetGameViewController, nil] animated:YES];
    
}




@end
