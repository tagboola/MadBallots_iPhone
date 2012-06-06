//
//  CardViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "CandidateOverviewController.h"
#import "CandidateViewController.h"

@implementation CardViewController
@synthesize dataArray;


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
    self.title = @"Fill Card";
    //TODO:Set title with category information
    pageControlBeingUsed = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * (dataArray.count + 1) ,scrollView.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, 0);
    pageControl.numberOfPages = dataArray.count + 1;
    pageControl.currentPage = 0;
    CandidateOverviewController *firstView = [[CandidateOverviewController alloc] initWithStyle:UITableViewStylePlain];
    firstView.contestants = dataArray;
    firstView.view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    firstView.delegate = self;
    [self.scrollView addSubview:firstView.view];
    viewControllers = [NSMutableArray array];
    [viewControllers addObject:firstView];
    CandidateViewController *candidateView;
    for(int ii=0;ii < [dataArray count]; ii++){
        candidateView = [[CandidateViewController alloc] initWithNibName:@"CandidateViewController" bundle:nil andContestant:[dataArray objectAtIndex:ii]];
        candidateView.view.frame = CGRectMake(self.scrollView.frame.size.width * (ii+1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        candidateView.delegate = self;
        [self.scrollView addSubview:candidateView.view];
        [viewControllers addObject:candidateView];
    }
    candidateView.valueTextField.returnKeyType = UIReturnKeyDone;
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





@end
