//
//  AppDelegate.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RestKit.h"
//#import "Game.h"
#import "Player.h"
//#import "Contestant.h"
//#import "Candidate.h"
//#import "GamesViewController.h"
//#import "GameViewController.h"
//#import "CardViewController.h"
//#import "VoteViewController.h"
#import "MBLoginViewController.h"
#import "MBWebAppViewController.h"
#import "MBAuthentication.h"
#import "MBAuthenticationInfo.h"
#import "MBAuthenticationCredentials.h"
#import "MBNotificationActionHandler.h"
#import "MBNotificationActionVote.h"
#import "MBNotificationActionFillCard.h"
#import "MBNotificationActionRSVP.h"
#import "MBNetworkErrorViewController.h"
#import "MBPlayerSession.h"
#import "SFHFKeychainUtils.h"
#import "AFHTTPClient.h"
//#import "Ballot.h"





@implementation AppDelegate

@synthesize window = _window;
@synthesize facebook;
@synthesize currentPlayer;
@synthesize rootNavController;
@synthesize isAuthenticated;
@synthesize deviceToken;
@synthesize notificationProcessor;



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
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MBLoginViewController *vc = [[MBLoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]; //   [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [app.window.rootViewController presentViewController:vc animated:YES completion:^{}];
}


-(void)showReachabilityModal{
    MBNetworkErrorViewController *networkErrView = [[MBNetworkErrorViewController alloc] initWithNibName:@"MBNetworkErrorViewController" bundle:nil];
    [networkErrView setModalPresentationStyle:UIModalTransitionStyleCrossDissolve];
    [[AppDelegate topViewController] presentViewController:networkErrView animated:YES completion:^{}];
}


-(void)dismissReachabilityModal{
    NSString *currentModalClass = NSStringFromClass([AppDelegate topViewController].class);
    if ([currentModalClass isEqualToString:@"MBNetworkErrorViewController"]){
        [[AppDelegate topViewController].presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }
    [self requestPlayerSession];
    [[AppDelegate webAppView] reload];
}


+(UIViewController *)topViewController{
    AppDelegate *app = [AppDelegate getInstance];
    UIViewController *topViewController = app.window.rootViewController;
    while (topViewController.presentedViewController){
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}


+(void)dismissLogin{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

+(UIWebView *)webAppView{
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return (UIWebView *)[[app.window.rootViewController.view subviews] objectAtIndex:0];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //TODO: Application crashes if reachability fails
    [self initHttpClient];
   

    //Try to create a session with the stored PToken. We'll set it to "" if we can't find one.
    //If we receive a 401 error (token not valid), we'll display the login
    [self requestPlayerSession];
    
    //init a facebook object
    [self initializeFacebookSession];

    // Override point for customization after application launch.
    //rootNavController = (UINavigationController *)self.window.rootViewController;
    
    

    // Override point for customization after application launch.
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.bounds = CGRectMake(0, -20, self.window.frame.size.width, self.window.frame.size.height);
    //MBWebAppViewController *webAppViewController = [[MBWebAppViewController alloc] initWithNibName:@"MBWebAppViewController" bundle:nil];
    //GamesViewController *gamesViewController = [[GamesViewController alloc] initWithNibName:@"GamesViewController" bundle:nil];
    //self.rootNavController = nil; //[[UINavigationController alloc] init];
    //self.window.rootViewController = //webAppViewController; //self.rootNavController;
    //[self.window makeKeyAndVisible];

    
    
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
    
    [[RKObjectManager sharedManager] postObject:session path:nil parameters:nil success:^
     
     //SUCCESS RESPONSE
     (RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
       
        if ( mappingResult.firstObject ){
            Player *player = (Player *)mappingResult.firstObject;
            if (player){
                self.currentPlayer = player;
                [[NSUserDefaults standardUserDefaults] setValue:player.playerId forKey:USER_ID_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [SFHFKeychainUtils storeUsername:player.playerId andPassword:player.persistenceToken forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
                //[(GamesViewController *)rootNavController.topViewController refreshUI];
                [(MBWebAppViewController *)self.window.rootViewController refreshUI];
                
                
                [self submitDeviceTokenForPlayer:self.currentPlayer];
                
                /*NSString *deviceTokenString = [NSString stringWithFormat:@"%@", self.deviceToken];
                NSString *formattedDeviceTokenString = [deviceTokenString substringWithRange:NSMakeRange(1, [deviceTokenString length] - 2)];
                if ([formattedDeviceTokenString isEqualToString:@"null"])
                    formattedDeviceTokenString =@"796ed65c f80dbeae 2f9858f1 60b7e46d cca6d1ad 9a8d59af a13d0369 e65a8f6b";
                self.currentPlayer.appleDeviceToken = formattedDeviceTokenString;
                
                //Update the Player's appleDeviceID
                [[RKObjectManager sharedManager] putObject:self.currentPlayer delegate:NULL];*/
                
                [AppDelegate dismissLogin];
            }else{ //Handle the error?
                
            }
        }
         
         
        //FAILURE RESPONSE
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Request Failed With Error: %@", [error localizedDescription]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:FACEBOOK_ID_KEY];
            //TODO: Tell current view to refresh and show error
            if (operation.HTTPRequestOperation.response.statusCode == 401){ //Unauthorized - invalid ptoken. Let's show the login screen.
                [AppDelegate showLogin];
            }
        }];
    
    
    
//    [[RKObjectManager sharedManager] postObject:session usingBlock:^ (RKObjectLoader *loader) {
//        loader.targetObject = [[Player alloc] init];
//        loader.delegate = self;
//    }];
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
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/logout" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self processLogout];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load: %@", [error localizedDescription]);
    }];
    
    
    //[[[RKObjectManager sharedManager] client] get:@"/logout" delegate:self];
    [AppDelegate showLogin];
}

-(void)processLogout{
    [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
    [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"fb_token" updateExisting:YES error:NULL];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:FACEBOOK_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [AppDelegate showLogin];
}


#pragma mark Apple Remote Notification delegate methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    self.deviceToken = devToken;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
    self.deviceToken = NULL;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    BOOL showDialog = NO;
    self.notificationProcessor = [[MBNotificationProcessor alloc] initWithNotification:userInfo];
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    if (appState == UIApplicationStateActive){
        showDialog = YES;
    }
    [self.notificationProcessor processNotificationWithDialog:showDialog];
    
}

  
  
// Pre iOS 4.2 support

#pragma mark FBSessionDelegate


-(void) fbDidLogin {
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
        
        [[RKObjectManager sharedManager] postObject:auth path:nil parameters:nil success:^
         
         (RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        } failure:^
         
         (RKObjectRequestOperation *operation, NSError *error) {
        
         }];
        
        
        //Request the authentication
//        [[RKObjectManager sharedManager] postObject:auth usingBlock:^ (RKObjectLoader *loader) {
//            loader.targetObject = [[Player alloc] init];
//            loader.delegate = self;
//        }];

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

//-(void)reachabilityStatusChanged:(NSNotification *)notification{
//    
//    RKReachabilityObserver *observer = (RKReachabilityObserver *)notification.object;
//    if (observer.isReachabilityDetermined){
//        if (observer.isNetworkReachable){ //We're good to go
//            
//            NSLog(@"Hello");
//            
//        }else{ //Display an alert and let the user know the connection ain't working
//            
//            UIAlertView *reachAV = [[UIAlertView alloc] initWithTitle:@"Cannot connect to Internet" message:@"Mad Ballots requires an internet connection to play. Please be sure that your device is connected to the Internet and try again." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
//            reachAV.tag = 0;
//            [reachAV show];
//        
//        }
//    }
//
//}


/*-(BOOL)checkNetworkStatus{
    
    //RKCLient *client = [[RKObjectManager sharedManager] client]
    
    
    
}*/



//-(void)initHttpClient{ //WithUsername:(NSString *)username password:(NSString*)password{
    
    
    
//}


-(void)initHttpClient{ //:(RKClient *)client{
    
    
    
    //Initialize RESTKit singleton instance
    //RKClient *client = [RKClient clientWithBaseURL:[NSURL URLWithString:BASE_URL]];
    //client.serviceUnavailableAlertEnabled = YES;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityStatusChanged:)
//                                                 name:RKReachabilityDidChangeNotification object:client.reachabilityObserver];

    //[client setUsername:username];
    //[client setPassword:password];
    
    
    //Initialize RESTKit singleton instance
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelCritical);
    RKLogConfigureByName("RestKit/Network", RKLogLevelCritical); 
    
    //Initialize ObjectManageger singleton instance
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    manager.requestSerializationMIMEType = @"application/json";

    //Setup Provider Object Mappings[Player getObjectMapping]
    
    //REQUEST MAPPINGS (for the most part using inverseMappings of response mappings).
        [manager addRequestDescriptorsFromArray:@[
                                              [RKRequestDescriptor requestDescriptorWithMapping:[[Player getObjectMapping] inverseMapping] objectClass:[Player class] rootKeyPath:@"player" method:RKRequestMethodAny],
                                              [RKRequestDescriptor requestDescriptorWithMapping:[[MBAuthentication getObjectMapping] inverseMapping] objectClass:[MBAuthentication class] rootKeyPath:@"omniauth.auth" method:RKRequestMethodAny],
                                              [RKRequestDescriptor requestDescriptorWithMapping:[[MBPlayerSession getObjectMapping] inverseMapping] objectClass:[MBPlayerSession class] rootKeyPath:@"player_session" method:RKRequestMethodAny]]
     ];
    
    
     //RESPONSE MAPPINGS
    [manager addResponseDescriptorsFromArray:@[
                                              [RKResponseDescriptor responseDescriptorWithMapping:[Player getObjectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"player" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
                                             [RKResponseDescriptor responseDescriptorWithMapping:[MBAuthentication getObjectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"authentication" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)],
                                              [RKResponseDescriptor responseDescriptorWithMapping:[MBPlayerSession getObjectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"player_session" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]]
     ];
    
                                               
    
    
    //RKObjectMappingProvider *provider = [RKObjectMappingProvider objectMappingProvider];
    //[provider registerMapping:[Game getObjectMapping] withRootKeyPath:@"game"];
    //[provider registerMapping:[Player getObjectMapping] withRootKeyPath:@"player"];
    //[provider registerMapping:[MBAuthentication getObjectMapping] withRootKeyPath:@"omniauth.auth"];
    //[provider registerMapping:[MBPlayerSession getObjectMapping] withRootKeyPath:@"player_session"];
    //[provider registerMapping:[Contestant getObjectMapping] withRootKeyPath:@"contestant"];
    //[provider registerMapping:[Candidate getObjectMapping] withRootKeyPath:@"candidate"];
    //[provider registerMapping:[Ballot getObjectMapping] withRootKeyPath:@"ballot"];
    //[provider registerMapping:[Ticket getObjectMapping] withRootKeyPath:@"ticket"];
    //[provider registerMapping:[Round getObjectMapping] withRootKeyPath:@"round"];
    //[provider addObjectMapping:[Round getObjectMapping]];
    //[provider addObjectMapping:[Player getObjectMapping]];
    
    
    //Setup Provider Serializations
    //RKObjectMapping *contestantSerializationMapping = [Contestant getSerializationMapping];
    //contestantSerializationMapping.rootKeyPath = @"contestant";
    //[provider setSerializationMapping:contestantSerializationMapping forClass:[Contestant class]];
    //[provider setSerializationMapping:[Contestant getSerializationMapping] forClass:[Contestant class]];
    //[provider setSerializationMapping:[Candidate getSerializationMapping] forClass:[Candidate class]];
    //[provider setSerializationMapping:[[Game getObjectMapping] inverseMapping] forClass:[Game class]];
     
    //manager.mappingProvider = provider;

    
    //Setup Routes
    RKRouter *router = [RKObjectManager sharedManager].router;
    
    //[router.routeSet addRoute:[RKRoute routeWithClass:[Game class] pathPattern:@"/games.json" method:RKRequestMethodPOST]]; //routeClass:[Game class] toResourcePath:@"/games.json" forMethod:RKRequestMethodPOST];
    
    [router.routeSet addRoute:[RKRoute routeWithClass:[Player class] pathPattern:@"/players.json" method:RKRequestMethodPOST]];//  routeClass:[Player class] toResourcePath:@"/players.json" forMethod:RKRequestMethodPOST];
    
    [router.routeSet addRoute:[RKRoute routeWithClass:[Player class] pathPattern:@"/players/:playerId" method:RKRequestMethodPUT]];// routeClass:[Player class] toResourcePath:@"/players/:playerId" forMethod:RKRequestMethodPUT];
    
    [router.routeSet addRoute:[RKRoute routeWithClass:[MBAuthentication class] pathPattern:@"/authentications.json" method:RKRequestMethodPOST]];
    // routeClass:[MBAuthentication class] toResourcePath:@"/authentications.json" forMethod:RKRequestMethodPOST];
    
    [router.routeSet addRoute:[RKRoute routeWithClass:[MBPlayerSession class] pathPattern:@"/player_sessions.json" method:RKRequestMethodPOST]]; // routeClass:[MBPlayerSession class] toResourcePath:@"/player_sessions.json" forMethod:RKRequestMethodPOST];
    
    
    //[router routeClass:[Candidate class] toResourcePath:@"/candidates/:candidateId\\.json" forMethod:RKRequestMethodPUT];
    //[router routeClass:[Contestant class] toResourcePathPattern:@"/contestants/:contestantId\\.json" forMethod:RKRequestMethodPUT];
    ////[router routeClass:[Contestant class] toResourcePath:@"/contestants/:contestantId\\.json" forMethod:RKRequestMethodPUT];
    //[router routeClass:[Contestant class] toResourcePath:@"players/:playerId/contestants.json" forMethod:RKRequestMethodGET];
    //[router routeClass:[Contestant class] toResourcePath:@"/contestants.json" forMethod:RKRequestMethodPOST];
    //[router routeClass:[Ballot class] toResourcePath:@"/ballots.json" forMethod:RKRequestMethodPOST];
    //[router routeClass:[Round class] toResourcePath:@"/rounds.json" forMethod:RKRequestMethodPOST];
    //[router routeClass:[Round class] toResourcePath:@"/rounds/:roundId\\.json" forMethod:RKRequestMethodPUT];

    
    [RKObjectManager setSharedManager:manager];
    
    [manager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self showReachabilityModal];
        } else if ((status == AFNetworkReachabilityStatusReachableViaWiFi) || (status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            [self dismissReachabilityModal];
        }
    }];
    
        
}


#pragma mark Device Token Helper methods

-(NSString *)formattedDeviceTokenString{
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@", self.deviceToken];
    NSString *formattedDeviceTokenString = [deviceTokenString substringWithRange:NSMakeRange(1, [deviceTokenString length] - 2)];
    if ([formattedDeviceTokenString isEqualToString:@"null"])
        formattedDeviceTokenString =@"796ed65c f80dbeae 2f9858f1 60b7e46d cca6d1ad 9a8d59af a13d0369 e65a8f6b";
    return formattedDeviceTokenString;
}


-(void)submitDeviceTokenForPlayer:(Player *)aPlayer{
    aPlayer.appleDeviceToken = [self formattedDeviceTokenString];
    //Update the Player's appleDeviceID
    [[RKObjectManager sharedManager] putObject:aPlayer path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"device ID captured succesfully");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to Capture Device ID");
    }];
    
    
    
    //[[RKObjectManager sharedManager] putObject:aPlayer delegate:NULL];
}



#pragma mark RKObjectLoaderDelegate methods



//
//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//    NSLog(@"Did post player: %@", objects);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[facebook accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
//    [defaults setObject:[facebook expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
//    [defaults synchronize];
//    //TODO: Tell current view to refresh
//    
//    NSString *objectClass = NSStringFromClass([[objectLoader targetObject] class]);
//    if ( [objectClass isEqualToString:@"Player"] ){ //Process player
//        Player *player = [objects objectAtIndex:0];
//        if (player){
//            self.currentPlayer = player;
//            [[NSUserDefaults standardUserDefaults] setValue:player.playerId forKey:USER_ID_KEY];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            [SFHFKeychainUtils storeUsername:player.playerId andPassword:player.persistenceToken forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
//            //[(GamesViewController *)rootNavController.topViewController refreshUI];
//            [(MBWebAppViewController *)self.window.rootViewController refreshUI];
//
//            
//            [self submitDeviceTokenForPlayer:self.currentPlayer];
//            
//            NSString *deviceTokenString = [NSString stringWithFormat:@"%@", self.deviceToken];
//            NSString *formattedDeviceTokenString = [deviceTokenString substringWithRange:NSMakeRange(1, [deviceTokenString length] - 2)];
//            if ([formattedDeviceTokenString isEqualToString:@"null"])
//                formattedDeviceTokenString =@"796ed65c f80dbeae 2f9858f1 60b7e46d cca6d1ad 9a8d59af a13d0369 e65a8f6b";
//            self.currentPlayer.appleDeviceToken = formattedDeviceTokenString;          
//            //Update the Player's appleDeviceID
//            [[RKObjectManager sharedManager] putObject:self.currentPlayer delegate:NULL];            
//            
//            [AppDelegate dismissLogin];
//        }else{ //Handle the error?
//            
//        }
//    }
//
//}
//
//

//
//
//- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
//    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:FACEBOOK_ID_KEY];
//    //TODO: Tell current view to refresh and show error
//    
//    if ([objectLoader response].isUnauthorized){ //Unauthorized - invalid ptoken. Let's show the login screen.
//        [AppDelegate showLogin];
//    }
//    
//}
//

#pragma mark RKRequestDelegate methods

//- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
//    NSLog(@"Failed to load: %@", [error localizedDescription]);
//}
//
//- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
//
//    //HANDLE LOGOUT - Remove stored information
//    if ([response.bodyAsString isEqualToString:LOGOUT_RESPONSE_STRING]){
//        [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
//        [SFHFKeychainUtils storeUsername:@"" andPassword:@"" forServiceName:@"fb_token" updateExisting:YES error:NULL];
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USER_ID_KEY];
//        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:FACEBOOK_ID_KEY];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    
//}
//
//- (void)request:(RKRequest *)request didReceivedData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExectedToReceive:(NSInteger)totalBytesExpectedToReceive{}
//
//- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{}
//
//- (void)requestDidCancelLoad:(RKRequest *)request{}
//
//- (void)requestDidStartLoad:(RKRequest *)request{}
//
//- (void)requestDidTimeout:(RKRequest *)request{}
//        
//        

#pragma mark RKRequestQueueDelegate methods
//- (void)requestQueue:(RKRequestQueue *)queue willSendRequest:(RKRequest *)request{
//    //NSLog(@"Will send reqeust");
//}
//- (void)requestQueue:(RKRequestQueue *)queue didCancelRequest:(RKRequest *)request{}
//- (void)requestQueue:(RKRequestQueue *)queue didFailRequest:(RKRequest *)request withError:(NSError *)error{}
//- (void)requestQueue:(RKRequestQueue *)queue didSendRequest:(RKRequest *)request{}        
//- (void)requestQueueDidBeginLoading:(RKRequestQueue *)queue{}
//
//- (void)requestQueueDidFinishLoading:(RKRequestQueue *)queue{
//    NSLog(@"Request Here");
//}
//
//- (void)requestQueueWasSuspended:(RKRequestQueue *)queue{}
//- (void)requestQueueWasUnsuspended:(RKRequestQueue *)queue{}



#pragma mark UIAlertViewDelegateMethods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Cannot connect to Internet"]){
        if (buttonIndex == 0){ //Retry Button
            //[self initHttpClient];
        }
    }
}




@end