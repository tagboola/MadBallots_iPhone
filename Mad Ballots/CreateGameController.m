//
//  GameRequestController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define MAXIMUM_NUMBER_OF_INVITES 5
#define MINIMUM_NUMBER_OF_INVITES 2

#import "CreateGameController.h"
#import "Player.h"
#import "Game.h"

@implementation CreateGameController
@synthesize nameTextField;
@synthesize numOfRoundsTextField;
@synthesize playerInviteTextField;
@synthesize invitedPlayers;
@synthesize tableView;
@synthesize inviteButton;
@synthesize createGameButton;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.invitedPlayers = [[NSMutableArray alloc] init];
    self.tableView.allowsSelection = NO;
    self.title = @"New Game";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)startLoading{
    
}

-(void)stopLoading{
    
}

-(IBAction)inviteButtonClicked:(id) sender{
    if([self.playerInviteTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME_KEY]]){
        [[[UIAlertView alloc] initWithTitle:@"You can't invite yourself" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    for(Player *player in self.invitedPlayers){
        if([player.username isEqualToString:self.playerInviteTextField.text]){
           [[[UIAlertView alloc] initWithTitle:@"You can't invite a player twice" message:@"Please enter another username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show]; 
            return;
        }
    }
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    self.createGameButton =  [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    
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
    
    //TODO: Fails on second attempt to to create game
    [[RKObjectManager sharedManager].router routeClass:[Game class] toResourcePath:resourcePath forMethod:RKRequestMethodPOST];
    [[RKObjectManager sharedManager] postObject:newGame delegate:self];

}




#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    
    NSLog(@"Loaded collection of Objects: %@", objects);
    
    if([objects count] > 0){
        NSString *objectClass = NSStringFromClass([[objects objectAtIndex:0] class]);

        if ( [objectClass isEqualToString:@"Player"] ){ //Process player
            Player *player = [objects objectAtIndex:0];
            [self.invitedPlayers addObject:player];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.invitedPlayers count] - 1) inSection:2];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = player.username;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if([self.invitedPlayers count] == MAXIMUM_NUMBER_OF_INVITES)
                self.inviteButton.userInteractionEnabled = NO;
            [self.tableView reloadData];
        }else if  ( [objectClass isEqualToString:@"Game"] ){ //Process Game
            
        }
    }else
        [[[UIAlertView alloc] initWithTitle:@"Username not found" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    

}

@end
