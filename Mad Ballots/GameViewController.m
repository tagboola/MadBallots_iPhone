//
//  GameViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "CreateGameController.h"

@implementation GameViewController

@synthesize contestant;
@synthesize acceptGameInvitationToolbar;
@synthesize startGameToolbar;
@synthesize fillCardButton;
@synthesize voteButton;
@synthesize gameNameLabel;
@synthesize categoryLabel;
@synthesize roundLabel;
@synthesize contestants;
@synthesize tableView;

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

-(void) updateButtons{
    //TODO:Add remove game button
    self.fillCardButton.userInteractionEnabled = self.contestant.card != nil && ![self.contestant.card isCardFilled];
    self.voteButton.userInteractionEnabled = self.contestant.card != nil && ![self.contestant.card isVoteCast];
    self.navigationItem.rightBarButtonItem.enabled = (self.contestants && [self.contestant.game iAmOwner] && ![self.contestant.game hasGameStarted] && [self.contestants count] <  MAXIMUM_NUMBER_OF_INVITES+1);

}

-(void) showToolbar:(UIToolbar*)toolbar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    toolbar.frame = CGRectMake(0, 372, toolbar.frame.size.width, toolbar.frame.size.height);
    [UIView commitAnimations];
}                    

-(void) hideToolbar:(UIToolbar*)toolbar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    toolbar.frame = CGRectMake(0, 416, toolbar.frame.size.width, toolbar.frame.size.height);
    [UIView commitAnimations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"invitePlayers"]) {
        CreateGameController *createGameView = [segue destinationViewController];
        NSMutableArray *invitedContestants = [NSMutableArray array];
        for(Contestant *gameContestant in contestants){
            if(![gameContestant.playerId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:USER_ID_KEY]]){
                [invitedContestants addObject:gameContestant.player];
            }
        }
        createGameView.playersToBeInvited = [NSMutableArray array];
        [createGameView.playersToBeInvited addObjectsFromArray:invitedContestants];
        createGameView.game = self.contestant.game;
        createGameView.numberOfPlayersAlreadyInvited = [contestants count] - 1;
        
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Uncomment the following line to preserve selection between presentations.
    [self updateButtons];
    self.gameNameLabel.text = self.contestant.game.name;
    self.categoryLabel.text = [self.contestant getCategory];
    self.roundLabel.text = [self.contestant getRoundDescription];
    //TODO: Allows other users to invite friends as well?? (Field on game objects)
    //TODO: Only invite users before the game starts?
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fillCardButton = nil;
    self.acceptGameInvitationToolbar = nil;
    self.voteButton = nil;
    self.gameNameLabel = nil;
    self.categoryLabel = nil;
    self.roundLabel = nil;
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *path = [NSString stringWithFormat:@"games/%@/contestants.json", contestant.gameId,contestant.contestantId];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path objectMapping:[Contestant getObjectMapping] delegate:self];
    if([self.contestant isInvitation])
        [self showToolbar:self.acceptGameInvitationToolbar];
     
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)acceptGameInvitation:(id)sender
{
    contestant.status = @"1";
    RKObjectMappingProvider *mapper = [[RKObjectMappingProvider alloc] init];
    RKObjectRouter *router = [[RKObjectRouter alloc] init];
    [mapper registerMapping:[Contestant getPostObjectMapping] withRootKeyPath:@"contestant"];
    [router routeClass:[Contestant class] toResourcePath:[NSString stringWithFormat:@"/contestants/%@.json", contestant.contestantId] forMethod:RKRequestMethodPUT];
    [RKObjectManager sharedManager].mappingProvider = mapper;
    [RKObjectManager sharedManager].router = router;
    [[RKObjectManager sharedManager] putObject:contestant delegate:self];
}


-(IBAction)rejectGameInvitation:(id)sender
{
    contestant.status = @"-1";
    RKObjectMappingProvider *mapper = [[RKObjectMappingProvider alloc] init];
    RKObjectRouter *router = [[RKObjectRouter alloc] init];
    [mapper registerMapping:[Contestant getPostObjectMapping] withRootKeyPath:@"contestant"];
    [router routeClass:[Contestant class] toResourcePath:[NSString stringWithFormat:@"/contestants/%@.json", contestant.contestantId] forMethod:RKRequestMethodPUT];
    [RKObjectManager sharedManager].mappingProvider = mapper;
    [RKObjectManager sharedManager].router = router;
    [[RKObjectManager sharedManager] putObject:contestant delegate:self];
} 
-(BOOL) allContestantsResponded{
    for(Contestant *gameContestant in self.contestants){
        if([gameContestant isInvitation])
            return false;
    }
    return true;
}

#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contestants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GameCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    Contestant *cellContestant = [self.contestants objectAtIndex:indexPath.row];
    cell.textLabel.text = cellContestant.player.username;
    if([self.contestant.game hasGameStarted]){
        cell.detailTextLabel.text = cellContestant.score;
    }else{
        cell.detailTextLabel.text = @"";
        if(![cellContestant isInvitation])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    //TODO - Add support showing pictures
    cell.imageView.image = [UIImage imageNamed:@"default_list_user.png"];
    
    
    return cell;
}



#pragma mark UITableViewDelegate methods



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}




#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"Load collection of Contestants: %@", objects);
    //TODO: Duplicated Code
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"games/%@/contestants.json", contestant.gameId,contestant.contestantId]]){
        self.contestants = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
        //TODO: Do we start when all users have repsonded or when minimum number of users have responded??
        if([self.contestant.game iAmOwner] && ![self.contestant.game hasGameStarted] && [self allContestantsResponded] && [contestants count] >= MINIMUM_NUMBER_OF_INVITES)
            [self showToolbar:startGameToolbar];
        if([contestants count] < MINIMUM_NUMBER_OF_INVITES+1)
            [[[UIAlertView alloc] initWithTitle:@"Invite more friends!" message:[NSString stringWithFormat:@"You need atleast %d players to start a game", MINIMUM_NUMBER_OF_INVITES+1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        //TODO: If everyone can invite, must check to see if this is just an invitation before inviting other players
        [self updateButtons];
    }
    //TODO:Duplicated Code
    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"/contestants/%@.json", contestant.contestantId]]){
        if([(Contestant*)objectLoader.sourceObject hasRejectedInvite])
            [self.navigationController popViewControllerAnimated:YES];
        else{
            [self hideToolbar:acceptGameInvitationToolbar];
            for(Contestant *gameContestant in contestants){
                if([gameContestant.contestantId isEqualToString:contestant.contestantId])
                    gameContestant.status = @"1";
            }
            [self.tableView reloadData];
        }
    }
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    //TODO: Show error for each type of requests
    
}


@end
