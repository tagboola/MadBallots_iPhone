//
//  GameViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

@synthesize contestant;
@synthesize acceptGameInvitationToolbar;
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

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations. 
    self.gameNameLabel.text = self.contestant.game.name;
    self.categoryLabel.text = [self.contestant getCategory];
    self.roundLabel.text = [self.contestant getRoundDescription];
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
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.acceptGameInvitationToolbar.frame = CGRectMake(0, 372, self.acceptGameInvitationToolbar.frame.size.width, self.acceptGameInvitationToolbar.frame.size.height);
        [UIView commitAnimations];
    }
    
     
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
    [router routeClass:[Contestant class] toResourcePath:@"/contestants/%@.json" forMethod:RKRequestMethodPUT];
    [RKObjectManager sharedManager].mappingProvider = mapper;
    [RKObjectManager sharedManager].router = router;
    [[RKObjectManager sharedManager] postObject:contestant delegate:self];
}


-(IBAction)rejectGameInvitation:(id)sender
{
    contestant.status = @"-1";
    RKObjectMappingProvider *mapper = [[RKObjectMappingProvider alloc] init];
    RKObjectRouter *router = [[RKObjectRouter alloc] init];
    [mapper registerMapping:[Contestant getPostObjectMapping] withRootKeyPath:@"contestant"];
    [router routeClass:[Contestant class] toResourcePath:@"/contestants/%@.json" forMethod:RKRequestMethodPOST];
    [RKObjectManager sharedManager].mappingProvider = mapper;
    [RKObjectManager sharedManager].router = router;
    [[RKObjectManager sharedManager] postObject:contestant delegate:self];
}

#pragma mark UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return nil;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contestants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GameCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    Contestant *cellContestant = [self.contestants objectAtIndex:indexPath.row];
    cell.textLabel.text = cellContestant.player.username;
    cell.detailTextLabel.text = cellContestant.score;
    if(![cellContestant isInvitation])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //TODO - Add support showing owners pictures
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

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
     
    NSLog(@"Load collection of Contestants: %@", objects);
    self.contestants = [NSMutableArray arrayWithArray:objects];
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
    
}


@end
