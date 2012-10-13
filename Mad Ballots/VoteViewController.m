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
@synthesize isOwner;
@synthesize cardId;
@synthesize tickets;
@synthesize viewControllerHash;
@synthesize candidatesHash;
@synthesize submitButton;

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
    self.candidatesHash = [[NSMutableDictionary alloc] init];
    viewControllers = [NSMutableArray array];
    BOOL showResults = false;
    if([round isRoundOver]){
        self.navigationItem.rightBarButtonItem = nil;
        showResults = true;
    }

//    TicketOverviewViewController *firstView = [[TicketOverviewViewController alloc] initWithStyle:UITableViewStylePlain showResults:YES tickets:tickets candidates:candidates delegate:self];
//    [viewControllers addObject:firstView];
    
    TicketViewController *ticketView;
    for(int ii=0;ii < [tickets count]; ii++){
        Ticket *ticket = [tickets objectAtIndex:ii];
        ticketView = [[TicketViewController alloc] initWithNibName:@"TicketViewController" bundle:nil];
        ticketView.isShowingResults = showResults;
        ticketView.delegate = self;
        ticketView.ticket = ticket;
        ticketView.cardId = cardId;
        ticketView.isOwner = isOwner;
        if(showResults){
            [self.candidatesHash setObject:ticket.winners forKey:ticket.contestantId];
        }
        ticketView.candidateHash = self.candidatesHash;
        [viewControllers addObject:ticketView];
        [viewControllerHash setObject:ticketView forKey:ticket.contestantId];
    }
    
    [super setupUI];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/candidates.json",round.roundId] usingBlock:^(RKObjectLoader *loader) {
        //TODO: Optimize this
        loader.onDidLoadObjects = ^(NSArray * objects){
            [self stopLoading];
            TicketViewController *ticketView;
            for(Candidate *candidate in objects){
                if(![candidate.cardId isEqualToString:cardId] || isOwner){
                    ticketView = [viewControllerHash objectForKey:candidate.contestantId];
                    [ticketView.candidates addObject:[NSMutableArray arrayWithObject:candidate]];
                }
            }
            //TODO: Refactor - TicketOverviewController involved in this
            for(TicketViewController *ticketView in viewControllers){
                [ticketView analyzeCandidates]; 
            }
        };
        loader.onDidFailWithError = ^(NSError *error){
            [self stopLoading];
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
    self.scrollView.scrollEnabled = FALSE;
    self.titleLabel.text = [NSString stringWithFormat:@"What %@ is...",round.category];
    self.navigationItem.rightBarButtonItem = submitButton;

    [self startLoading:@"Loading ballots..."];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/tickets.json",round.roundId] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray * objects){
            tickets = objects;
            [self loadViewControllers];
        };
        loader.onDidFailWithError = ^(NSError *error){
            [self stopLoading];
            NSLog(@"Error loading candidates for round:%@", [error localizedDescription]);
        };
    }];
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.submitButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)castVoteButtonClicked:(id)sender{
    if([candidatesHash count] != [tickets count]){
        [[[UIAlertView alloc] initWithTitle:@"Ticket incomplete" message:@"Place your vote for each player before submitting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [self startLoading:@"Casting vote..."];
    Ballot *ballot = [[Ballot alloc] init];
    for(Ticket *ticket in tickets){
        ballot.ticketId = ticket.ticketId;
        ballot.contestantId = contestantId;
        NSArray *candidatesArray = [candidatesHash objectForKey:ticket.contestantId];
        [self startLoading:@"Submitting Votes..."];
        for(Candidate *candidate in candidatesArray){
            ballot.candidateId = candidate.candidateId;
            [[RKObjectManager sharedManager] postObject:ballot usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray * objects){
                    RKRequestQueue *queue = [[RKObjectManager sharedManager] requestQueue]; 
                    if(queue.count == 1)
                        [self.navigationController popViewControllerAnimated:YES];
                };
                loader.onDidFailWithError = ^ (NSError *error){
                    [self stopLoading];
                    NSLog(@"Ballot post falled with error:%@",[error localizedDescription]);
            };
            }];
        }
        [self stopLoading];
    }
}




@end
