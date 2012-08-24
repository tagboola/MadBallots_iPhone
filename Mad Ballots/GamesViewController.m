//
//  MasterViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GamesViewController.h"
#import "GameViewController.h"
#import "CreateGameViewController.h"
#import "Game.h"
#import "Contestant.h"



@implementation GamesViewController

@synthesize gamesArray;
@synthesize sectionTitleArray;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    //TODO: Handle Memory Warning
}

-(void) loadGames{
    if([AppDelegate currentPlayer].playerId){
        if ([[gamesArray objectAtIndex:0] count] == 0 && [[gamesArray objectAtIndex:1] count] == 0)
            [self startLoading:@"Loading games..."];
        NSString *contestantsPath = [NSString stringWithFormat:@"players/%@/contestants.json",[AppDelegate currentPlayer].playerId];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:contestantsPath delegate:self];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Games";
    self.gamesArray = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    self.sectionTitleArray = [NSArray arrayWithObjects:@"Game Invitations",@"Active Games", nil];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = loginLogoutButton;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = newGameButton;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self navigationController].toolbarHidden = FALSE;
    [self refreshUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#if __IPHONE_5_0
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showGameViewController"]) {
        GameViewController *gameView = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contestant *contestant = [[self.gamesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        gameView.contestant = contestant;
    }
    
}
 */
#endif



-(IBAction)createNewGame:(id)sender
{
    //NSLog(@"new game");
    /*(if ([[segue identifier] isEqualToString:@"showGameViewController"]) {
        GameViewController *gameView = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Contestant *contestant = [[self.gamesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        gameView.contestant = contestant;
    }*/
    
    CreateGameViewController *createGameView = [[CreateGameViewController alloc] initWithNibName:@"CreateGameView" bundle:nil];
    [self.navigationController pushViewController:createGameView animated:YES];    

    
}


-(IBAction)logout:(id)sender
{
    if ([AppDelegate getInstance].currentPlayer){
//        welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", [AppDelegate getInstance].currentPlayer.name];
//        loginLogoutButton.title = @"Logout";
        self.gamesArray = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app logout:sender];
    }else{
//        loginLogoutButton.title = @"Login";
        [AppDelegate showLogin];
    }
    [[AppDelegate getInstance] logout:sender];
}


-(void)refreshUI
{
    //Reload the Welcome Label
    if ([AppDelegate getInstance].currentPlayer){
        welcomeLabel.text = [NSString stringWithFormat:@"Welcome, %@", [AppDelegate getInstance].currentPlayer.name];
        loginLogoutButton.title = @"Logout";
//        loginLogoutButton.target = [AppDelegate getInstance];
//        loginLogoutButton.action = @selector(logout:);
    }else{
        loginLogoutButton.title = @"Login";
//        loginLogoutButton.target = [AppDelegate class];
//        loginLogoutButton.action = @selector(showLogin:);
    }
    [self loadGames];
    
}


#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitleArray objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.gamesArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GamesCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Contestant *contestant = [[self.gamesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = contestant.game.name;
    NSString *hostString = ([contestant.gameOwner isEqualToString:[[AppDelegate currentPlayer] username]]) ? @"ME!" : contestant.gameOwner;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hosted By: %@\r%@", hostString, [contestant getGameStatus]];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.minimumFontSize = 12;
    if([contestant isActionNeeded])
        cell.detailTextLabel.textColor = [UIColor redColor];
    else
        cell.detailTextLabel.textColor = [UIColor blackColor];
    //TODO - Add support showing owners pictures
    cell.imageView.image = [UIImage imageNamed:@"default_list_user.png"];
    

    return cell;
}






#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GameViewController *gameView = [[GameViewController alloc] initWithNibName:@"MBGameView" bundle:nil];
    Contestant *contestant = [[self.gamesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    gameView.contestant = contestant;
    [self.navigationController pushViewController:gameView animated:YES];    
}



#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    [self stopLoading];
    self.gamesArray = [NSArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    if([objects count] > 0)
    {    
        for(Contestant *contestant in objects){
            if([contestant isInvitation])
                [[self.gamesArray objectAtIndex:0] addObject:contestant];
            else
                [[self.gamesArray objectAtIndex:1] addObject:contestant];
        }
    }
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    [self stopLoading];
    //TODO Check error message and show appropriate message
    [[[UIAlertView alloc] initWithTitle:@"Unable to load games" message:@"Please check network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}





@end
