//
//  AppDelegate.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "RestKit.h"
#import "Player.h"
#import "MBRootNavigationController.h"

@class Player;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate,FBRequestDelegate,RKObjectLoaderDelegate, RKRequestQueueDelegate>{
    Facebook *facebook;
    Player *currentPlayer;
    MBRootNavigationController *rootNavController;
    BOOL isAuthenticated;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Facebook *facebook;
@property (nonatomic, retain) Player *currentPlayer;
@property (nonatomic, retain) MBRootNavigationController *rootNavController;
@property BOOL isAuthenticated;

+(AppDelegate *)getInstance;
+(Player *)currentPlayer;
+(Facebook *)facebook;
+(void)showLogin;
+(void)dismissLogin;


-(void)loginToFacebook:(id)sender;
-(void)initHttpClientWithUsername:(NSString *)username password:(NSString*)password;
-(void)logout:(id)sender;


-(void)requestPlayerSession;

@end
