//
//  GameRequestController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "CreateGameViewController.h"
#import "Game.h"
#import "PlayerRequestViewController.h"
#import "Contestant.h"
#import "AppDelegate.h"
#import "Facebook.h"

@implementation CreateGameViewController
@synthesize numberOfPlayersAlreadyInvited;
@synthesize game;
@synthesize nameTextField;
@synthesize numOfRoundsTextField;
@synthesize playerInviteTextField;
@synthesize playersToBeInvited;
@synthesize tableView;
@synthesize inviteButton;
@synthesize createGameButton;
@synthesize nameTableViewCell;
@synthesize roundTableViewCell;
@synthesize usernameTableViewCell;
@synthesize facebookTableViewCell;
@synthesize facebookTableViewCellLabel;

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

- (void)allowPlayerInvitations:(BOOL)allowed {
    self.inviteButton.userInteractionEnabled = allowed;
    self.facebookTableViewCell.userInteractionEnabled = allowed;
    self.playerInviteTextField.userInteractionEnabled = allowed;
}

- (void)invitePlayer:(Player *)player{
    //TODO: Protect the array from exceding the maximum number of invites
    for(Player *invitedPlayer in self.playersToBeInvited){
        if([invitedPlayer.username isEqualToString:player.username]){
            if(self.navigationController.visibleViewController == self)
                [[[UIAlertView alloc] initWithTitle:@"You can't invite a player twice" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
            return;
        }
    }
    [self.playersToBeInvited addObject:player];
    [self.tableView reloadData];
    if([self.playersToBeInvited count] == MAXIMUM_NUMBER_OF_INVITES){
        [self allowPlayerInvitations:NO];
    }
}

-(void)invitePlayersToGame:(Game *)aGame{
    for(int ii=numberOfPlayersAlreadyInvited ;ii < [playersToBeInvited count];ii++){
        Player *player = [playersToBeInvited objectAtIndex:ii];
        Contestant *newContestant = [[Contestant alloc] init];
        newContestant.gameId = [aGame gameId];
        newContestant.playerId = [player playerId];
        newContestant.status = @"0";
        [[RKObjectManager sharedManager] postObject:newContestant delegate:NULL];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Enable/disable the invite facebook button
    //facebookTableViewCell. = ([AppDelegate facebook].isSessionValid) ? YES : NO;
    
    if(!playersToBeInvited){
        playersToBeInvited = [NSMutableArray array];
    }
    // Do any additional setup after loading the view from its nib.
    if(game){
        self.nameTextField.text = game.name;
        self.numOfRoundsTextField.text = game.numberOfRounds;
        self.nameTextField.userInteractionEnabled = NO;
        self.numOfRoundsTextField.userInteractionEnabled = NO;
        self.title = @"Invite Players";
        [self.navigationItem.rightBarButtonItem setTitle:@"Invite"];
    }
    else
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
    if([self.playerInviteTextField.text isEqualToString:[[AppDelegate currentPlayer] username]]){
        [[[UIAlertView alloc] initWithTitle:@"You can't invite yourself" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [self.playerInviteTextField resignFirstResponder];
    NSString * resourcePath = [NSString stringWithFormat:@"players.json?username=%@",[self.playerInviteTextField text]];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath delegate:self]; //loadObjectsAtResourcePath:resourcePath objectMapping:[Player getObjectMapping] delegate:self];
    
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
    if([self.playersToBeInvited count] < MINIMUM_NUMBER_OF_INVITES){
        [[[UIAlertView alloc] initWithTitle:@"You need to invite more users" message:[NSString stringWithFormat:@"Minimum of %d players needed to play",(MINIMUM_NUMBER_OF_INVITES+1)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
        return NO;
    }
    return YES;
}



-(IBAction)createGameButtonClicked:(id) sender{
    if(![self isGameValid])
        return;
    if(!game){ //CREATE A NEW GAME
        Game *newGame = [[Game alloc] init];
        newGame.name = self.nameTextField.text;
        newGame.ownerId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
        newGame.numberOfRounds = self.numOfRoundsTextField.text;
        [[RKObjectManager sharedManager] postObject:newGame delegate:self];
    }else{ //GAME ALREADY EXISTS - JUST INVITING PLAYERS
        [self invitePlayersToGame:[self game]];
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPlayerRequestViewController"]) {
        PlayerRequestViewController *playerRequestView = [segue destinationViewController];
        playerRequestView.invitedPlayers =  [playersToBeInvited copy];
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
    else if(indexPath.section == 1 && indexPath.row == 1){
        if (![AppDelegate facebook].isSessionValid){
            facebookTableViewCell.userInteractionEnabled = NO;
            facebookTableViewCellLabel.textColor = [UIColor grayColor];
        }else{
            facebookTableViewCell.userInteractionEnabled = YES;
            facebookTableViewCellLabel.textColor = [UIColor blackColor];
        }
        return facebookTableViewCell;
    }
    
    static NSString *CellIdentifier = @"InvitedPlayersCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([playersToBeInvited count] <= indexPath.row){
        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = nil;
        return cell;
    }
    //TODO show invited players image
    Player *player = [playersToBeInvited objectAtIndex:indexPath.row];
    cell.textLabel.text = player.username;
    if(indexPath.row <= numberOfPlayersAlreadyInvited - 1)
        cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    
    return cell;
}

#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row <= numberOfPlayersAlreadyInvited - 1)
        return;
    if(indexPath.section == 2 && [playersToBeInvited count] > indexPath.row){
        [playersToBeInvited removeObjectAtIndex:indexPath.row];
        if([playersToBeInvited count] == MAXIMUM_NUMBER_OF_INVITES - 1)
            [self allowPlayerInvitations:YES];        
        [self.tableView reloadData];
    }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded collection of Players: %@", objects);
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"players.json?username=%@",self.playerInviteTextField.text]]){
        if([objects count] > 0){
            Player *player = [objects objectAtIndex:0];
            [self invitePlayer:player];
        }else
            [[[UIAlertView alloc] initWithTitle:@"Username not found" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else if ([[objectLoader.targetObject class] isEqual:[Game class]]){ //It's a game
        //ADD THE PLAYERS AS CONTESTANTS
        [self invitePlayersToGame:(Game *)objectLoader.targetObject];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"players.json?username=%@",self.playerInviteTextField.text]]){
        //TODO: Duplicated Code
        [[[UIAlertView alloc] initWithTitle:@"Username not found" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error creating game" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end