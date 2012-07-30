//
//  ContactsRequestTableViewController.m
//  BarHopTest
//
//  Created by Tunde Agboola on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerRequestViewController.h"
#import "AppDelegate.h"
#import "SFHFKeychainUtils.h"
#import "Player.h"
#import "CreateGameViewController.h"

#define MAX_NUMBER_OF_INVITES MAXIMUM_NUMBER_OF_INVITES - [self.invitedPlayers count]


@implementation PlayerRequestViewController

@synthesize playersArray;
@synthesize searchPlayersArray;
@synthesize selectedPlayersArray;
@synthesize invitedPlayers;
@synthesize facebook;


static NSString * const ID = @"facebookID";
static NSString * const IMAGE_URL = @"imageURL";
static NSString * const NAME = @"name";
static NSString * const CHECKED = @"checked";


#pragma mark -
#pragma mark Initialization




#pragma mark -
#pragma mark View lifecycle


-(void) getFacebookFriends{
    [self startLoading:@"Loading friends..."];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];;
	NSString *fb_ID = [prefs objectForKey:FACEBOOK_ID_KEY];
    NSString *fbAccessToken = [SFHFKeychainUtils getPasswordForUsername:fb_ID andServiceName:@"fb_token" error:NULL];
	NSString *fql = [NSString stringWithFormat:@"SELECT name,pic_square_with_logo,uid FROM user WHERE is_app_user = 1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@)",fb_ID]; /*Put this in the where clause: is_app_user = 1 AND */
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"query"];
	[params setObject:fbAccessToken forKey:@"access_token"];
    [[AppDelegate facebook] requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"GET"          andDelegate:self];
	NSLog(@"Facebook GET Application Friends by FQL");
}



- (void)viewDidLoad {
    [super viewDidLoad];

	self.playersArray = [NSMutableArray array];
	self.searchPlayersArray = [NSMutableArray array];
    self.selectedPlayersArray = [NSMutableArray arrayWithCapacity:MAXIMUM_NUMBER_OF_INVITES];
    
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [
 [super viewWillAppear:animated];
 }
 */

 - (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
     if([[AppDelegate facebook] isSessionValid]){
         [self getFacebookFriends];
     }else{
         [[AppDelegate getInstance] loginToFacebook:self];
     }
 }

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

-(IBAction)addSelectedPlayers:(id)sender{
    [self startLoading:@"Inviting players..."];
    for(NSDictionary *facebookDictionary in selectedPlayersArray){
        //TODO: Search for authorizations instead of player
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/players.json?facebook_id=%@",[facebookDictionary objectForKey:ID]] delegate:self];
    
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.searchDisplayController.active){
		return [self.searchPlayersArray count];}
	else{
		return [self.playersArray count];}
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
	
	// Configure the cell...
	NSDictionary *element;
	if(tableView == self.searchDisplayController.searchResultsTableView){
		element = [self.searchPlayersArray objectAtIndex:indexPath.row];}
	else{
		element = [self.playersArray objectAtIndex:indexPath.row];}
   
    
    if([[element objectForKey:CHECKED] intValue] == 1)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [element objectForKey:NAME];
    //TODO: Add image support
    cell.imageView.image = [UIImage imageNamed:@"defaut_list_user.png"];

	return cell;
}






#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *activePlayerArray;
    UITableView *activeTableView;
    if(self.searchDisplayController.active){
        activePlayerArray = self.searchPlayersArray;
        activeTableView = self.searchDisplayController.searchResultsTableView;
    }else{
        activePlayerArray = self.playersArray;
        activeTableView = self.tableView;
    }
    
    UITableViewCell *cell = [activeTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *player = [activePlayerArray objectAtIndex:indexPath.row];
    if(cell.accessoryType == UITableViewCellAccessoryNone && [selectedPlayersArray count] < MAX_NUMBER_OF_INVITES ){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [player setValue:[NSNumber numberWithInt:1] forKey:CHECKED];
        [selectedPlayersArray addObject:player];
    }else if(cell.accessoryType == UITableViewCellAccessoryCheckmark && [selectedPlayersArray count] <= MAX_NUMBER_OF_INVITES ){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [player setValue:[NSNumber numberWithInt:0] forKey:CHECKED];
        [selectedPlayersArray removeObject:player];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.playersArray = nil;
    self.searchPlayersArray = nil;
}





- (void)request:(FBRequest*)request didLoad:(id)result {
    NSLog(@"%@",result);
    [self stopLoading];
	NSArray* users = result;
	if([users count]>0){
		NSLog(@"User has %d friends using this app",[users count]);
		NSLog(@"%@",users);
		for (NSDictionary *user in users) 
		{
            NSMutableDictionary *userObject = [[NSMutableDictionary alloc]init];
            [userObject setObject:[user objectForKey:@"name"] forKey:NAME];
            [userObject setObject:[user objectForKey:@"pic_square_with_logo"] forKey:IMAGE_URL];
            [userObject setObject:[user objectForKey:@"uid"] forKey:ID];
            [userObject setObject:[NSNumber numberWithInt:0] forKey:CHECKED];
            [self.playersArray addObject:userObject];
		}
		[self.playersArray sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc]initWithKey:NAME ascending:YES]]];
		[self.tableView reloadData];
	}
	else { 
        [[[UIAlertView alloc] initWithTitle:@"No friends playing Mad Ballots" message:@"Tell your friends about mad ballots so they can enjoy the fun" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
	
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
    NSLog(@"%@",[error description]);
    [self stopLoading];
    [[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
};
	

	
#pragma mark Content Filtering
	
- (void)filterContentForSearchText:(NSString*)searchText{
	//
	if([searchText length] >= 1)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	//Update the filtered array based on the search text and scope.
	[self.searchPlayersArray removeAllObjects]; 
	for (NSDictionary *dictionary in self.playersArray){
		NSString *name = [dictionary objectForKey:@"name"];
		NSRange resultsRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if (resultsRange.length > 0)
			[self.searchPlayersArray addObject:dictionary];}
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filterContentForSearchText:searchString];
	// Return YES to cause the search result table view to be reloaded.
	return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
	[self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
	// Return YES to cause the search result table view to be reloaded.
	return YES;
}
	

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded collection of Players: %@", objects);
    if([objects count] > 0){
        Player *player = [objects objectAtIndex:0];
        CreateGameViewController *createGameView = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
        [createGameView invitePlayer:player];
    }
    RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
    if(queue.count == 1){
        [self.navigationController popViewControllerAnimated:YES];
        [self stopLoading];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    //TODO: Display error messsages
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
    if(queue.count == 1){
        [self.navigationController popViewControllerAnimated:YES];
        [self stopLoading];

    }
}
	
	
@end
