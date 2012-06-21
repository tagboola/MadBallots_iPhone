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

@synthesize tickets;
@synthesize viewControllerHash;
@synthesize contestant;
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

-(void) setupUI{
    viewControllerHash = [NSMutableDictionary dictionary];
    
    self.candidates = [[NSMutableDictionary alloc] init];
    pageControl.numberOfPages = tickets.count + 1;
    pageControl.currentPage = 0;
    pageControlBeingUsed = NO;
    scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*pageControl.numberOfPages, self.scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake(0, 0);
    TicketOverviewViewController *firstView = [[TicketOverviewViewController alloc] initWithStyle:UITableViewStylePlain];
    firstView.tickets = tickets;
    firstView.candidates = candidates;
    firstView.delegate = self;
    firstView.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    firstView.tableView.frame = firstView.view.frame;
    [self.scrollView addSubview:firstView.view];
    viewControllers = [NSMutableArray array];
    [viewControllers addObject:firstView];
    TicketViewController *ticketView;
    for(int ii=0;ii < [tickets count]; ii++){
        Ticket *ticket = [tickets objectAtIndex:ii];
        ticketView = [[TicketViewController alloc] initWithNibName:@"TicketViewController" bundle:nil];
        ticketView.delegate = self;
        ticketView.ticket = ticket;
        ticketView.candidateHash = self.candidates;
        ticketView.view.frame = CGRectMake(self.scrollView.frame.size.width * (ii+1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:ticketView.view];
        [viewControllers addObject:ticketView];
        [viewControllerHash setObject:ticketView forKey:ticket.contestantId];
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/candidates.json",contestant.round.roundId] usingBlock:^(RKObjectLoader *loader) {
        //TODO: Optimize this
        loader.onDidLoadObjects = ^(NSArray * objects){
            TicketViewController *ticketView;
            for(Candidate *candidate in objects){
                if(![candidate.cardId isEqualToString:contestant.card.cardId]){
                    ticketView = [viewControllerHash objectForKey:candidate.contestantId];
                    [ticketView.candidates addObject:candidate];
                }
            }
            for(TicketViewController *ballotView in viewControllers)
                [ballotView.tableView reloadData];
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
    self.titleLabel.text = [NSString stringWithFormat:@"What %@ is...",contestant.round.category];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/tickets.json",contestant.round.roundId] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray * objects){
            tickets = objects;
            [self setupUI];
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
        ballot.contestantId = contestant.contestantId;
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
