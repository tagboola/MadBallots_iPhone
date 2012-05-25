//
//  AppDelegate.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RestKit.h"
#import "Game.h"
#import "Player.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Set up default user settings
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:@"3" forKey:USER_ID_KEY];
    [standardDefaults setObject:@"test" forKey:PASSWORD_KEY];
    [standardDefaults setObject:@"tunde5" forKey:USERNAME_KEY];
    [standardDefaults setObject:@"tunde5" forKey:NAME_KEY];
    [standardDefaults setObject:@"tunde5@gmail.com" forKey:EMAIL_KEY];
    [standardDefaults synchronize];
    
    //Initialize RESTKit singleton instance
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelCritical);
    RKLogConfigureByName("RestKit/Network", RKLogLevelCritical); 
    RKClient *client = [RKClient clientWithBaseURL:BASE_URL];
    [client setUsername:[standardDefaults objectForKey:USERNAME_KEY]];
    [client setPassword:[standardDefaults objectForKey:PASSWORD_KEY]];
    //Initialize ObjectManageger singleton instance
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:BASE_URL];
    [manager setClient:client];
    RKObjectMappingProvider *provider = [RKObjectMappingProvider objectMappingProvider];
    [provider registerMapping:[Game getObjectMapping] withRootKeyPath:@"game"];
    [provider registerMapping:[Player getObjectMapping] withRootKeyPath:@"player"];
    manager.mappingProvider = provider;
    manager.serializationMIMEType = @"application/json";
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    //[router routeClass:[Game class] toResourcePath:@"/games.json" forMethod:RKRequestMethodPOST];
//    [router routeClass:[Player class] toResourcePath:@"players/:playerId.json"];
    [router routeClass:[Player class] toResourcePath:@"/players.json" forMethod:RKRequestMethodPOST];
    [RKObjectManager setSharedManager:manager];
    
    
    self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:nil];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void) loginToFacebook{
    [self.facebook authorize:[NSArray arrayWithObjects: @"read_stream", @"offline_access",@"publish_stream",nil]];
}


// Pre iOS 4.2 support

#pragma mark FBSessionDelegate


-(void) fbDidLogin {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
//    [defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
//    [defaults synchronize];
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}


- (void)fbDidNotLogin:(BOOL)cancelled {
    [[[UIAlertView alloc] initWithTitle:@"Unable to login to Facebook" message:@"Please check network connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL handled = [facebook handleOpenURL:url];
    [self fbDidLogin];
    return handled;  
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [facebook handleOpenURL:url];
    [self fbDidLogin];
    return handled; 
}


-(void) fbDidLogout {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:FACEBOOK_ACCESS_TOKEN_KEY];
    [prefs removeObjectForKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    [prefs synchronize];
}
- (void)fbSessionInvalidated{
    
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    
}

#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
    NSLog(@"Facebook Request succeeded with response: %@", result);
    NSDictionary *hash = result;
    NSString *facebookId = [hash objectForKey:@"id"];
    if(facebookId){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:facebookId forKey:FACEBOOK_ID_KEY];
        [defaults synchronize];
        
        Player *player = [[Player alloc] init];
        player.playerId = [defaults objectForKey:USER_ID_KEY];
        player.name = [defaults objectForKey:NAME_KEY];
        player.username = [defaults objectForKey:USERNAME_KEY];
        player.email = [defaults objectForKey:EMAIL_KEY];
        player.facebookId = facebookId;
        
        RKObjectRouter *router = [[RKObjectRouter alloc] init];
        [router routeClass:[Player class] toResourcePath:[NSString stringWithFormat:@"players/%@.json",player.playerId]];
        [RKObjectManager sharedManager].router = router;
        [[RKObjectManager sharedManager] putObject:player delegate:self];
        
    }
    
}

- (void)request:(FBRequest*)request didFailWithError:(NSError *)error{
    NSLog(@"Facebook Request failed with error: %@",[error localizedDescription]);
}



#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Did post player: %@", objects);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
    [defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    [defaults synchronize];
    //TODO: Tell current view to refresh
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FACEBOOK_ID_KEY];
    //TODO: Tell current view to refresh and show error
    
}



@end
