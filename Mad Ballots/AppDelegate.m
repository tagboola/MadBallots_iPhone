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
#import "Contestant.h"
#import "GamesViewController.h"
#import "MBAuthentication.h"
#import "MBAuthenticationInfo.h"
#import "MBAuthenticationCredentials.h"
#import "MBPlayerSession.h"
#import "SFHFKeychainUtils.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize facebook;
@synthesize currentPlayer;
@synthesize rootNavController;
@synthesize isAuthenticated;



+(AppDelegate *)getInstance{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


+(Player *)currentPlayer{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return (Player *)app.currentPlayer;
}


+(Facebook *)facebook{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return (Facebook *)app.facebook;    
}

+(void)showLogin{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [app.window.rootViewController presentModalViewController:vc animated:YES];
}


+(void)dismissLogin{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController dismissModalViewControllerAnimated:YES];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Set up default user settings
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:@"5" forKey:USER_ID_KEY];
    [standardDefaults setObject:@"test" forKey:PASSWORD_KEY];
    [standardDefaults setObject:@"tunde4" forKey:USERNAME_KEY];
    [standardDefaults setObject:@"tunde4" forKey:NAME_KEY];
    [standardDefaults setObject:@"tunde4@gmail.com" forKey:EMAIL_KEY];
    [standardDefaults synchronize];
    
    //Try to create a session with the stored PToken. We'll set it to "" if we can't find one.
    //If we receive a 401 error (token not valid), we'll display the login
    [self requestPlayerSession];
    
    //init a facebook object
    [self initializeFacebookSession];

    // Override point for customization after application launch.
    rootNavController = (UINavigationController *)self.window.rootViewController;
    GamesViewController *gvc = (GamesViewController*)rootNavController.topViewController;
    

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


#pragma mark Actions

-(void) loginToFacebook:(id)sender{
    [self.facebook authorize:[NSArray arrayWithObjects: @"read_stream",@"publish_stream",nil]];
}


-(void)requestPlayerSession{
    NSString *playerId = @"";
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardDefaults objectForKey:USER_ID_KEY]) {
        playerId = [standardDefaults valueForKey:USER_ID_KEY] == nil ? @"" : [standardDefaults valueForKey:USER_ID_KEY];
    }
    NSString *ptoken = [SFHFKeychainUtils getPasswordForUsername:playerId andServiceName:@"mb_ptoken" error:NULL];
    MBPlayerSession *session = [[MBPlayerSession alloc] init];
    session.persistenceToken = (ptoken) ? ptoken : @"";
    [[RKObjectManager sharedManager] postObject:session usingBlock:^ (RKObjectLoader *loader) {
        loader.targetObject = [[Player alloc] init];
        loader.delegate = self;
    }];
}


-(void)initializeFacebookSession{
    self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:nil];
    NSString *fbId = @"";
    NSDate *fbExpDate = [NSDate date];
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardDefaults objectForKey:FACEBOOK_ID_KEY]) {
        fbId = [standardDefaults valueForKey:FACEBOOK_ID_KEY] == nil ? @"" : [standardDefaults valueForKey:FACEBOOK_ID_KEY];
    }
    if ([standardDefaults objectForKey:FACEBOOK_EXIPIRATION_DATE_KEY]) {
        fbExpDate = [standardDefaults valueForKey:FACEBOOK_EXIPIRATION_DATE_KEY] == nil ? @"" : [standardDefaults valueForKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    }
    NSString *fbAccessToken = [SFHFKeychainUtils getPasswordForUsername:fbId andServiceName:@"fb_token" error:NULL];
    facebook.accessToken = fbAccessToken;
    facebook.expirationDate = fbExpDate;
}



-(void)logout:(id)sender
{
    [[[RKObjectManager sharedManager] client] get:@"/logout" delegate:self];
    [AppDelegate showLogin];
}



// Pre iOS 4.2 support

#pragma mark FBSessionDelegate


-(void) fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:[facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
    //[defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    //[defaults synchronize];
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

        //Create an authentication with the facebook object
        MBAuthentication * auth = [[MBAuthentication alloc] init];
        auth.provider = @"facebook";
        auth.uid = facebookId;
        auth.info.name = [hash objectForKey:@"name"];
        auth.credentials.token = [facebook accessToken]; //[defaults objectForKey:FACEBOOK_ACCESS_TOKEN_KEY];
        
        //Request the authentication
        [[RKObjectManager sharedManager] postObject:auth usingBlock:^ (RKObjectLoader *loader) {
            loader.targetObject = [[Player alloc] init];
            loader.delegate = self;
        }];

        //Store the information in the defaults and/or keychain
        [SFHFKeychainUtils storeUsername:facebookId andPassword:[facebook accessToken] forServiceName:@"fb_token" updateExisting:YES error:NULL];
        [defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
        [defaults setObject:facebookId forKey:FACEBOOK_ID_KEY];
        [defaults synchronize];
        
        
    }
    
}

- (void)request:(FBRequest*)request didFailWithError:(NSError *)error{
    NSLog(@"Facebook Request failed with error: %@",[error localizedDescription]);
}


#pragma mark RestKit setup
-(void)initHttpClient{ //WithUsername:(NSString *)username password:(NSString*)password{
    
    //Initialize RESTKit singleton instance
    RKClient *client = [RKClient clientWithBaseURL:[NSURL URLWithString:BASE_URL]];
    //[client setUsername:username];
    //[client setPassword:password];
    
    //Initialize RESTKit singleton instance
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelCritical);
    RKLogConfigureByName("RestKit/Network", RKLogLevelCritical); 
    
    //Initialize ObjectManageger singleton instance
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.serializationMIMEType = @"application/json";
    [manager setClient:client];
    client.requestQueue.delegate = self;
    
    //Setup Provider Object Mappings
    RKObjectMappingProvider *provider = [RKObjectMappingProvider objectMappingProvider];
    [provider registerMapping:[Game getObjectMapping] withRootKeyPath:@"game"];
    [provider registerMapping:[Player getObjectMapping] withRootKeyPath:@"player"];
    [provider registerMapping:[MBAuthentication getObjectMapping] withRootKeyPath:@"omniauth.auth"];
    [provider registerMapping:[MBPlayerSession getObjectMapping] withRootKeyPath:@"player_session"];
    [provider registerMapping:[Contestant getObjectMapping] withRootKeyPath:@"contestant"];
    //[provider addObjectMapping:[Round getObjectMapping]];
    //[provider addObjectMapping:[Player getObjectMapping]];
    
    
    //Setup Provider Serializations
    RKObjectMapping *contestantSerializationMapping = [Contestant getSerializationMapping];
    contestantSerializationMapping.rootKeyPath = @"contestant";
    [provider setSerializationMapping:contestantSerializationMapping forClass:[Contestant class]];
    //[provider setSerializationMapping:[[Game getObjectMapping] inverseMapping] forClass:[Game class]];
    
    manager.mappingProvider = provider;

    
    //Setup Routes
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[Game class] toResourcePath:@"/games.json" forMethod:RKRequestMethodPOST];
    //[router routeClass:[Player class] toResourcePath:@"players/:playerId"];
    [router routeClass:[Player class] toResourcePath:@"/players.json" forMethod:RKRequestMethodPOST];
    [router routeClass:[MBAuthentication class] toResourcePath:@"/authentications" forMethod:RKRequestMethodPOST];
    [router routeClass:[MBPlayerSession class] toResourcePath:@"/player_sessions" forMethod:RKRequestMethodPOST];
    [router routeClass:[Contestant class] toResourcePathPattern:@"/contestants/:contestantId\\.json" forMethod:RKRequestMethodPUT];
    [router routeClass:[Contestant class] toResourcePath:@"players/:playerId/contestants.json" forMethod:RKRequestMethodGET];
    [router routeClass:[Contestant class] toResourcePath:@"/contestants.json" forMethod:RKRequestMethodPOST];
    [RKObjectManager setSharedManager:manager];
        
}



#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Did post player: %@", objects);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
    [defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    [defaults synchronize];
    //TODO: Tell current view to refresh
    
    NSString *objectClass = NSStringFromClass([[objectLoader targetObject] class]);
    if ( [objectClass isEqualToString:@"Player"] ){ //Process player
        Player *player = [objects objectAtIndex:0];
        if (player){
            self.currentPlayer = player;
            [[NSUserDefaults standardUserDefaults] setValue:player.playerId forKey:USER_ID_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [SFHFKeychainUtils storeUsername:player.playerId andPassword:player.persistenceToken forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
            [(GamesViewController *)rootNavController.topViewController refreshUI];
            [AppDelegate dismissLogin];
        }else{ //Handle the error?
            
        }
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FACEBOOK_ID_KEY];
    //TODO: Tell current view to refresh and show error
    
    if ([objectLoader response].isUnauthorized){ //Unauthorized - invalid ptoken. Let's show the login screen.
        [AppDelegate showLogin];
    }
    
}


#pragma mark RKRequestDelegate methods

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"Failed to load: %@", [error localizedDescription]);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{

    //HANDLE LOGOUT - Remove stored information
    if ([response.bodyAsString isEqualToString:LOGOUT_RESPONSE_STRING]){
        [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
        [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"fb_token" updateExisting:YES error:NULL];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_ID_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:FACEBOOK_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive{}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{}

- (void)requestDidCancelLoad:(RKRequest *)request{}

- (void)requestDidStartLoad:(RKRequest *)request{}

- (void)requestDidTimeout:(RKRequest *)request{}
        
        
        
#pragma mark RKRequestQueueDelegate methods
- (void)requestQueue:(RKRequestQueue *)queue willSendRequest:(RKRequest *)request{
    NSLog(@"Will send reqeust");
}
- (void)requestQueue:(RKRequestQueue *)queue didCancelRequest:(RKRequest *)request{}
- (void)requestQueue:(RKRequestQueue *)queue didFailRequest:(RKRequest *)request withError:(NSError *)error{}
- (void)requestQueue:(RKRequestQueue *)queue didSendRequest:(RKRequest *)request{}        
- (void)requestQueueDidBeginLoading:(RKRequestQueue *)queue{}

- (void)requestQueueDidFinishLoading:(RKRequestQueue *)queue{
    NSLog(@"Request Here");
}

- (void)requestQueueWasSuspended:(RKRequestQueue *)queue{}
- (void)requestQueueWasUnsuspended:(RKRequestQueue *)queue{}


@end
