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
#import "MBNotificationProcessor.h"

@class Player;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate,FBRequestDelegate>{
    Facebook *facebook;
    Player *currentPlayer;
    UINavigationController *rootNavController;
    BOOL isAuthenticated;
    NSData *deviceToken;
    MBNotificationProcessor *notificationProcessor;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Facebook *facebook;
@property (nonatomic, retain) Player *currentPlayer;
@property (nonatomic, retain) UINavigationController *rootNavController;
@property (nonatomic, retain) NSData *deviceToken;
@property BOOL isAuthenticated;
@property (nonatomic, retain) MBNotificationProcessor *notificationProcessor;

+(AppDelegate *)getInstance;
+(Player *)currentPlayer;
+(Facebook *)facebook;
+(void)showLogin;
+(void)dismissLogin;
+(UIWebView *)webAppView;


-(void)loginToFacebook:(id)sender;
-(void)initHttpClient;
-(void)initializeFacebookSession;
-(void)logout:(id)sender;
-(void)processLogout;


-(void)requestPlayerSession;
-(NSString *)formattedDeviceTokenString;
-(void)submitDeviceTokenForPlayer:(Player *)aPlayer;

@end
