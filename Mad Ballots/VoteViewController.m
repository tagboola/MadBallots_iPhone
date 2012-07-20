//
//  TickerViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoteViewController.h"
#import "TicketOverviewViewController.h"
#import "TicketViewController.h"
#import "Contestant.h"
#import "Ticket.h"
#import "Candidate.h"
#import "Ballot.h"

@implementation VoteViewController

@synthesize round;
@synthesize contestantId;
@synthesize cardId;
@synthesize tickets;
@synthesize viewControllerHash;
@synthesize candidates;

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

-(void) loadViewControllers{
    
    self.viewControllerHash = [NSMutableDictionary dictionary];
    self.candidates = [[NSMutableDictionary alloc] init];
    viewControllers = [NSMutableArray array];
    BOOL showResults = false;
    if([round isRoundOver]){
        self.navigationItem.rightBarButtonItem = nil;
        showResults = true;
    }

    TicketOverviewViewController *firstView = [[TicketOverviewViewController alloc] initWithStyle:UITableViewStylePlain showResults:YES tickets:tickets candidates:candidates delegate:self];
    [viewControllers addObject:firstView];
    
    TicketViewController *ticketView;
    for(int ii=0;ii < [tickets count]; ii++){
        Ticket *ticket = [tickets objectAtIndex:ii];
        ticketView = [[TicketViewController alloc] initWithNibName:@"TicketViewController" bundle:nil];
        ticketView.delegate = self;
        ticketView.ticket = ticket;
        if(ticket.winners){
            [self.candidates setObject:ticket.winners forKey:ticket.contestantId];
        }
        ticketView.candidateHash = self.candidates;
        [viewControllers addObject:ticketView];
        [viewControllerHash setObject:ticketView forKey:ticket.contestantId];
    }
    
    [super setupUI];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/candidates.json",round.roundId] usingBlock:^(RKObjectLoader *loader) {
        //TODO: Optimize this
        loader.onDidLoadObjects = ^(NSArray * objects){
            TicketViewController *ticketView;
            for(Candidate *candidate in objects){
                if(![candidate.cardId isEqualToString:cardId]){
                    ticketView = [viewControllerHash objectForKey:candidate.contestantId];
                    [ticketView.candidates addObject:candidate];
                }
            }
            //TODO: Refactor - TicketOverviewController involved in this
            for(TicketViewController *ballotView in viewControllers){
            if([ballotView class] == [TicketViewController class])
                [ballotView reloadData];
            else
                [ballotView.tableView reloadData];
            }
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error loading candidates for round:%@",[error localizedDescription]);
        };
    }];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.round = [[Round alloc] init];
    self.round.roundId = @"1";
    self.round.category = @"Insect";
    self.titleLabel.text = [NSString stringWithFormat:@"What %@ is...",round.category];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/tickets.json",round.roundId] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray * objects){
            tickets = objects;
            [self loadViewControllers];
        };
        loader.onDidFailWithError = ^(NSError *error){
            NSLog(@"Error loading candidates for round:%@", [error localizedDescription]);
        };
    }];
    

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

-(IBAction)submitButtonClicked:(id)sender{
    if([candidates count] != [tickets count]){
        [[[UIAlertView alloc] initWithTitle:@"Ticket incomplete" message:@"Place your vote for each player before submitting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    Ballot *ballot = [[Ballot alloc] init];
    for(Ticket *ticket in tickets){
        ballot.ticketId = ticket.ticketId;
        ballot.contestantId = contestantId;
        ballot.candidateId = ((Candidate*)[candidates objectForKey:ticket.contestantId]).candidateId;
        [[RKObjectManager sharedManager] postObject:ballot usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray * objects){
                RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
                if(queue.count == 1)
                    [self.navigationController popViewControllerAnimated:YES];
            };
            loader.onDidFailWithError = ^ (NSError *error){
                NSLog(@"Ballot post falled with error:%@",[error localizedDescription]);
        };
        }];
    }
}

@end
