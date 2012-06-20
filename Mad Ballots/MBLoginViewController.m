//
//  MBLoginViewController.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBLoginViewController.h"
#import "AppDelegate.h"
#import "MBAuthentication.h"
#import "MBAuthenticationInfo.h"
#import "MBAuthenticationCredentials.h"
#import "SFHFKeychainUtils.h"

@interface MBLoginViewController ()

@end

@implementation MBLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

#pragma mark - Login Actions


-(BOOL) loginValid{
    if([self.usernameTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Username is required" message:@"Please enter a username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    
    if([self.passwordTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Password is required" message:@"Please enter a password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    
    return YES;
}


- (IBAction)login:(UIButton *)sender {
    
    if (![self loginValid])
        return;
    
    //Create an authentication
    MBAuthentication * auth = [[MBAuthentication alloc] init];
    auth.provider = MAD_BALLOTS_AUTH_PROVIDER_STRING;
    auth.uid = [self.usernameTextField text];
    auth.credentials.secret = [self.passwordTextField text];
    
    //Request the authentication
    [[RKObjectManager sharedManager] postObject:auth usingBlock:^ (RKObjectLoader *loader) {
        loader.targetObject = [[Player alloc] init];
        loader.delegate = self;
    }];

}



- (IBAction)loginWithFacebook:(UIButton *)sender {
    [[AppDelegate getInstance] loginToFacebook:self]; // authorize:@"read_stream",@"publish_stream",nil];
}




- (IBAction)createAccount:(UIButton *)sender {
}


#pragma mark FBSessionDelegate

-(void) fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[AppDelegate facebook] accessToken] forKey:FACEBOOK_ACCESS_TOKEN_KEY];
    [defaults setObject:[[AppDelegate facebook] expirationDate] forKey:FACEBOOK_EXIPIRATION_DATE_KEY];
    [defaults synchronize];
    [[AppDelegate facebook] requestWithGraphPath:@"me" andDelegate:self];
}


- (void)fbDidNotLogin:(BOOL)cancelled {
    [[[UIAlertView alloc] initWithTitle:@"Unable to login to Facebook" message:@"Please check network connection and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL handled = [[AppDelegate facebook] handleOpenURL:url];
    [self fbDidLogin];
    return handled;  
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[AppDelegate facebook] handleOpenURL:url];
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
        auth.credentials.token = [defaults objectForKey:FACEBOOK_ACCESS_TOKEN_KEY];
        
        //Request the authentication
        [[RKObjectManager sharedManager] postObject:auth usingBlock:^ (RKObjectLoader *loader) {
            loader.targetObject = nil;
            loader.delegate = self;
        }];
        
        
        //Store the information in the defaults
        [defaults setObject:facebookId forKey:FACEBOOK_ID_KEY];
        [defaults synchronize];
        
    }
    
}

- (void)request:(FBRequest*)request didFailWithError:(NSError *)error{
    NSLog(@"Facebook Request failed with error: %@",[error localizedDescription]);
}




#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    NSLog(@"Did authenticate player: %@", objects);
    Player *player = [objects objectAtIndex:0];
    if (player){
        [AppDelegate getInstance].currentPlayer = player;
        [[NSUserDefaults standardUserDefaults] setValue:player.playerId forKey:USER_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SFHFKeychainUtils storeUsername:player.playerId andPassword:player.persistenceToken forServiceName:@"mb_ptoken" updateExisting:YES error:NULL];
    }      
    
    [self dismissModalViewControllerAnimated:YES];    

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    //TODO: Tell current view to refresh
    
}


@end
