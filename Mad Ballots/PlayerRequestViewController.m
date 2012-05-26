//
//  ContactsRequestTableViewController.m
//  BarHopTest
//
//  Created by Tunde Agboola on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerRequestViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SFHFKeychainUtils.h"



@implementation PlayerRequestViewController

@synthesize playersArray;
@synthesize searchPlayersArray;
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
	
	UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(addSelectedPlayers)];
	self.navigationItem.rightBarButtonItem = acceptButton;
	self.playersArray = [[NSMutableArray alloc] init];
	self.searchPlayersArray = [[NSMutableArray alloc] init];
    
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [
 [super viewWillAppear:animated];
 }
 */

 - (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
     /*self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:nil];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     if ([defaults objectForKey:FACEBOOK_ACCESS_TOKEN_KEY] && [defaults objectForKey:FACEBOOK_EXIPIRATION_DATE_KEY]) {
         facebook.accessToken = [defaults objectForKey:FACEBOOK_ACCESS_TOKEN_KEY];
         facebook.expirationDate = [defaults objectForKey:FACEBOOK_EXIPIRATION_DATE_KEY];
     }*/
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
   
    
    NSNumber *checked = [element objectForKey:CHECKED];
    if([checked intValue] == 1)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [element objectForKey:NAME];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[element objectForKey:IMAGE_URL]] placeholderImage:[UIImage imageNamed:@"default_list_user.png"]];

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
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [player setValue:[NSNumber numberWithInt:1] forKey:CHECKED];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [player setValue:[NSNumber numberWithInt:0] forKey:CHECKED];
    }
	
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
	
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	self.navigationItem.titleView.userInteractionEnabled = YES;
}

	
	
@end
