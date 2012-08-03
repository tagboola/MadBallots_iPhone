//
//  GameViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "CreateGameViewController.h"
#import "Round.h"
#import "CardViewController.h"
#import "VoteViewController.h"

@implementation GameViewController

@synthesize contestant;
@synthesize acceptGameInvitationToolbar;
@synthesize startGameToolbar;
@synthesize fillCardButton;
@synthesize voteButton;
@synthesize gameNameLabel;
@synthesize categoryLabel;
@synthesize roundLabel;
@synthesize gameContestants;
@synthesize rounds;
@synthesize tableView;
@synthesize previousRoundStatusLabel;
@synthesize addPlayerButton;

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

-(void) updateUI{
    self.gameNameLabel.text = self.contestant.game.name;
    self.categoryLabel.text = [self.contestant getCategory];
    self.roundLabel.text = [self.contestant getRoundDescription];
    //TODO:Add remove game button
    self.fillCardButton.userInteractionEnabled = self.contestant.card != nil && ![self.contestant.round areCardsFilled];
    //TODO:Change button to Edit Card if card is already filled
    //self.voteButton.userInteractionEnabled = (self.contestant.card != nil) && ![self.contestant.card isVoteCast];
    self.voteButton.userInteractionEnabled = YES;

    self.navigationItem.rightBarButtonItem.enabled = self.gameContestants && [self.contestant.game iAmOwner] && ![self.contestant hasGameStarted] && ([self.gameContestants count] <  MAXIMUM_NUMBER_OF_INVITES+1);

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

-(void) refreshContestant{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/contestants/%@.json",contestant.contestantId] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects) {
            self.contestant = (Contestant*)[objects objectAtIndex:0];
            [self updateUI];
            if([self.contestant.round isRoundOver])
                [self showToolbar:startGameToolbar];
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error loading contestant:%@",[error localizedDescription]);
        };
    }];
}


/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"invitePlayers"]) {
        CreateGameViewController *createGameView = [segue destinationViewController];
        NSMutableArray *invitedContestants = [NSMutableArray array];
        for(Contestant *gameContestant in gameContestants){
            if(![gameContestant.playerId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:USER_ID_KEY]]){
                [invitedContestants addObject:gameContestant.player];
            }
        }
        createGameView.playersToBeInvited = [NSMutableArray array];
        [createGameView.playersToBeInvited addObjectsFromArray:invitedContestants];
        createGameView.game = self.contestant.game;
        createGameView.numberOfPlayersAlreadyInvited = [gameContestants count] - 1;
        
    }else if([[segue identifier] isEqualToString:@"fillCard"]){
        CardViewController *cardView = [segue destinationViewController];
        cardView.cardId = self.contestant.card.cardId;
        cardView.category = self.contestant.round.category;
    }
    else if([[segue identifier] isEqualToString:@"showTicketViewController"]){
        VoteViewController *voteView = [segue destinationViewController];
        voteView.round = self.contestant.round;
        voteView.contestantId = self.contestant.contestantId;
        voteView.cardId = self.contestant.card.cardId;
    }else if([[segue identifier] isEqualToString:@"showPreviousRoundResults"]){
        if(self.rounds){
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"roundId" ascending:NO];
            self.rounds = [self.rounds sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            VoteViewController *voteView = [segue destinationViewController];
            voteView.round = [self.rounds objectAtIndex:1];
            voteView.contestantId = self.contestant.contestantId;
        }
    }
    
}
 */

-(BOOL) haveAllContestantsResponded{
    for(Contestant *gameContestant in self.gameContestants){
        if([gameContestant isInvitation])
            return false;
    }
    return true;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = addPlayerButton;

 
    [self updateUI];
    if(![self.contestant.previousRoundScore isEqualToString:@"-1"])
        self.previousRoundStatusLabel.text = [NSString stringWithFormat:@"You received %@ points last round",self.contestant.previousRoundScore];
    else
        self.previousRoundStatusLabel.text = @"";
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
    self.addPlayerButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //TODO: Refresh Contestant object
    NSString *path = [NSString stringWithFormat:@"games/%@/contestants.json", contestant.gameId,contestant.contestantId];
    if(!self.gameContestants)
        [self startLoading:@"Loading scores..."];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray* objects) {
            [self stopLoading];
            self.gameContestants = [NSMutableArray arrayWithArray:objects];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
            self.gameContestants = [NSMutableArray arrayWithArray:[self.gameContestants sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]]];
            [self.tableView reloadData];
            //TODO: Do we start when all users have repsonded or when minimum number of users have responded??
            if([self.contestant.game iAmOwner] && ![self.contestant hasGameStarted] && [self haveAllContestantsResponded] && [gameContestants count] >= MINIMUM_NUMBER_OF_INVITES)
                [self showToolbar:startGameToolbar];
            if([gameContestants count] < MINIMUM_NUMBER_OF_INVITES+1)
                [[[UIAlertView alloc] initWithTitle:@"Invite more friends!" message:[NSString stringWithFormat:@"You need atleast %d players to start a game", MINIMUM_NUMBER_OF_INVITES+1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            //TODO: If everyone can invite, must check to see if this is just an invitation before inviting other players
            [self updateUI];
        };
        loader.onDidFailWithError = ^(NSError *error){
            [self stopLoading];
            NSLog(@"Error loading contestants:%@",[error localizedDescription]);
        };

    }];
    //TODO: Refresh Contestant object
    path = [NSString stringWithFormat:@"/games/%@/rounds.json", contestant.gameId];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray* objects) {
            self.rounds = objects;
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error loading contestants:%@",[error localizedDescription]);
        };
        
    }];

    [self refreshContestant];
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



#pragma mark Actions


- (void) startNewRound{
    Round *round = [[Round alloc] init];
    round.state = @"0";
    round.voteStatus = @"0";
    round.cardStatus = @"0";
    round.gameId = self.contestant.gameId;
    [[RKObjectManager sharedManager] postObject:round usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray * objects){
            //Game was started
            [self hideToolbar:startGameToolbar];
            [self refreshContestant];
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error posting round:%@",[error localizedDescription]);
            
        };
    }];
}

- (void) closeRound{
    //Close previous round
    self.contestant.round.state = @"1";
    [[RKObjectManager sharedManager] putObject:self.contestant.round usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray * objects){
            [self startNewRound];
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error putting round:%@",[error localizedDescription]);
            
        };
    }];
}

-(IBAction)startGame:(id)sender
{
    if(self.contestant.round){
        [self closeRound];
        return;
    }
    [self startNewRound];
}

- (void)respondToGameInvitation
{

    [[RKObjectManager sharedManager] putObject:contestant usingBlock:^(RKObjectLoader *loader) {
        Contestant *newContestant = (Contestant*)loader.sourceObject;
        loader.onDidLoadObjects = ^(NSArray *objects){
            if([newContestant hasRejectedInvite])
                [self.navigationController popViewControllerAnimated:YES];
            else{
                [self hideToolbar:acceptGameInvitationToolbar];
                for(Contestant *gameContestant in gameContestants){
                    if([gameContestant.contestantId isEqualToString:contestant.contestantId])
                        gameContestant.status = @"1";
                }
                [self.tableView reloadData];
            }
            [self updateUI];
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error putting contestant:%@",[error localizedDescription]);
        };
    }];
}

-(IBAction)acceptGameInvitation:(id)sender
{
    contestant.status = @"1";
    [self respondToGameInvitation];
}

-(IBAction)rejectGameInvitation:(id)sender
{
    contestant.status = @"-1";
    [self respondToGameInvitation];
}


-(IBAction)fillCard:(id)sender
{
    CardViewController *cardView = [[CardViewController alloc] initWithNibName:@"CardView" bundle:nil];
    cardView.cardId = self.contestant.card.cardId;
    cardView.category = self.contestant.round.category;
    [self.navigationController pushViewController:cardView animated:YES];
}


-(IBAction)castVote:(id)sender
{
    VoteViewController *voteView = [[VoteViewController alloc] initWithNibName:@"MBVoteView" bundle:nil];
    voteView.round = self.contestant.round;
    voteView.contestantId = self.contestant.contestantId;
    voteView.cardId = self.contestant.card.cardId;
    [self.navigationController pushViewController:voteView animated:YES];
}


-(IBAction)viewResults:(id)sender
{
    if(self.rounds){
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"roundId" ascending:NO];
        self.rounds = [self.rounds sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        VoteViewController *voteView = [[VoteViewController alloc] initWithNibName:@"MBVoteView" bundle:nil];
        voteView.round = [self.rounds objectAtIndex:1];
        voteView.contestantId = self.contestant.contestantId;
        [self.navigationController pushViewController:voteView animated:YES];
    }
}

-(IBAction)addPlayers:(id)sender
{
    CreateGameViewController *createGameView = [[CreateGameViewController alloc] initWithNibName:@"CreateGameView" bundle:nil]; //[segue destinationViewController];
    NSMutableArray *invitedContestants = [NSMutableArray array];
    for(Contestant *gameContestant in gameContestants){
        if(![gameContestant.playerId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:USER_ID_KEY]]){
            [invitedContestants addObject:gameContestant.player];
        }
    }
    createGameView.playersToBeInvited = [NSMutableArray array];
    [createGameView.playersToBeInvited addObjectsFromArray:invitedContestants];
    createGameView.game = self.contestant.game;
    createGameView.numberOfPlayersAlreadyInvited = [gameContestants count] - 1;
    [self.navigationController pushViewController:createGameView animated:YES];
}

#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.gameContestants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GameCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    Contestant *cellContestant = [self.gameContestants objectAtIndex:indexPath.row];
    cell.textLabel.text = cellContestant.player.name;
    if([self.contestant hasGameStarted]){
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
//    NSLog(@"Load collection of Contestants: %@", objects);
//    //TODO:Duplicated Code
//    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"/contestants/%@.json", contestant.contestantId]]){
//        if([(Contestant*)objectLoader.sourceObject hasRejectedInvite])
//            [self.navigationController popViewControllerAnimated:YES];
//        else{
//            [self hideToolbar:acceptGameInvitationToolbar];
//            for(Contestant *gameContestant in gameContestants){
//                if([gameContestant.contestantId isEqualToString:contestant.contestantId])
//                    gameContestant.status = @"1";
//            }
//            [self.tableView reloadData];
//        }
//    }
//    //TODO:Duplicated Code
////    if([objectLoader.resourcePath isEqualToString:[NSString stringWithFormat:@"/rounds.json",self.contestant.gameId]]){
////
////    }
//    [self updateUI];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    //TODO: Show error for each type of requests
    
}


@end
