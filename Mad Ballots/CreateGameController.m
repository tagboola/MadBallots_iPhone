//
//  GameRequestController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define MINIMUM_NUMBER_OF_INVITES 2

#import "CreateGameController.h"
#import "Game.h"
#import "PlayerRequestViewController.h"

@implementation CreateGameController
@synthesize nameTextField;
@synthesize numOfRoundsTextField;
@synthesize playerInviteTextField;
@synthesize invitedPlayers;
@synthesize tableView;
@synthesize inviteButton;
@synthesize createGameButton;
@synthesize nameTableViewCell;
@synthesize roundTableViewCell;
@synthesize usernameTableViewCell;
@synthesize facebookTableViewCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)invitePlayer:(Player *)player{
    for(Player *invitedPlayer in self.invitedPlayers){
        if([invitedPlayer.username isEqualToString:player.username]){
            if(self.navigationController.visibleViewController == self)
                [[[UIAlertView alloc] initWithTitle:@"You can't invite a player twice" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
            return;
        }
    }
    [self.invitedPlayers addObject:player];
    [self.tableView reloadData];
    if([self.invitedPlayers count] == MAXIMUM_NUMBER_OF_INVITES){
        self.inviteButton.userInteractionEnabled = NO;
        self.facebookTableViewCell.userInteractionEnabled = NO;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.invitedPlayers = [NSMutableArray array];
    self.title = @"New Game";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)inviteButtonClicked:(id) sender{
    if([self.playerInviteTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME_KEY]]){
        [[[UIAlertView alloc] initWithTitle:@"You can't invite yourself" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [self.playerInviteTextField resignFirstResponder];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"players.json?username=%@",self.playerInviteTextField.text] objectMapping:[Player getObjectMapping] delegate:self];
    
}

-(BOOL) isGameValid{
    if([self.nameTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Name is required" message:@"Please enter a name for your game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    if([self.numOfRoundsTextField.text length] == 0){
        [[[UIAlertView alloc] initWithTitle:@"Number of rounds is required" message:@"Please enter the number of rounds you would like for your game" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    if([self.invitedPlayers count] < MINIMUM_NUMBER_OF_INVITES){
        [[[UIAlertView alloc] initWithTitle:@"You need to invite more users" message:[NSString stringWithFormat:@"Minimum of %d players needed to play",(MINIMUM_NUMBER_OF_INVITES+1)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    return YES;
}

-(IBAction)createGameButtonClicked:(id) sender{
    if(![self isGameValid])
        return;
    
    Game *newGame = [[Game alloc] init];
    newGame.name = self.nameTextField.text;
    newGame.ownerId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
    newGame.numberOfRounds = self.numOfRoundsTextField.text;
    

    NSString *resourcePath = @"/games.json?playerIds=";
    for(Player *player in self.invitedPlayers)
        resourcePath = [resourcePath stringByAppendingString:[NSString stringWithFormat:@"%@,",player.playerId]];
    resourcePath = [resourcePath substringToIndex:(resourcePath.length-1)];
    
    RKObjectRouter *router = [[RKObjectRouter alloc] init];
    [router routeClass:[Game class] toResourcePath:resourcePath forMethod:RKRequestMethodPOST];
    [RKObjectManager sharedManager].router = router;
    [[RKObjectManager sharedManager] postObject:newGame delegate:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPlayerRequestViewController"]) {
        PlayerRequestViewController *playerRequestView = [segue destinationViewController];
        playerRequestView.invitedPlayers =  [invitedPlayers copy];
    } 
    
}

#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0)
        return nameTableViewCell;
    else if(indexPath.section == 0 && indexPath.row == 1)
        return roundTableViewCell;
    else if(indexPath.section == 1 && indexPath.row == 0)
        return usernameTableViewCell;
    else if(indexPath.section == 1 && indexPath.row == 1)
        return facebookTableViewCell;
    
    static NSString *CellIdentifier = @"InvitedPlayersCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([invitedPlayers count] <= indexPath.row){
        //TODO clear image of invited player
        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    //TODO show invited players image
    Player *player = [invitedPlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = player.username;
    cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 2 && [invitedPlayers count] > indexPath.row){
        [invitedPlayers removeObjectAtIndex:indexPath.row];
        if([invitedPlayers count] == MAXIMUM_NUMBER_OF_INVITES - 1){
            self.inviteButton.userInteractionEnabled = YES;
            self.facebookTableViewCell.userInteractionEnabled = YES;
        }
        [self.tableView reloadData];
    }
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded collection of Players: %@", objects);
    //TODO Catch when game is returned and pop controller
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"players.json?username=%@",self.playerInviteTextField.text]]){
        if([objects count] > 0){
            Player *player = [objects objectAtIndex:0];
            [self invitePlayer:player];
        }else
            [[[UIAlertView alloc] initWithTitle:@"Username not found" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    //TODO Show error when objects bad username
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"players.json?username=%@",self.playerInviteTextField.text]]){
        [[[UIAlertView alloc] initWithTitle:@"Username not found" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        //TODO Show error when game there is an error creating a game
        [[[UIAlertView alloc] initWithTitle:@"Error creating game" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
