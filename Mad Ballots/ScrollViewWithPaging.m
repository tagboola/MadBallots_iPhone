//
//  ScrollViewWithPaging.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewWithPaging.h"

@implementation ScrollViewWithPaging

@synthesize titleLabel;
@synthesize scrollView;
@synthesize pageControl;

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

-(void)setupUI{
    pageControl.numberOfPages = viewControllers.count;
    pageControl.currentPage = 0;
    pageControlBeingUsed = NO;
    scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*pageControl.numberOfPages, self.scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake(0, 0);
    for(int ii = 0; ii < [viewControllers count]; ii++){
        UIViewController *viewController = [viewControllers objectAtIndex:ii];
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * ii, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

-(IBAction)changePage {
    [self changePage:self.pageControl.currentPage];
}

- (void)refreshOverviewController {
    UITableViewController *tableViewController = [viewControllers objectAtIndex:0];
    [tableViewController.tableView reloadData];
}

#pragma Mark - ScrollViewWithPaging Delegate methods
-(void)changePage:(int)page{
    self.pageControl.currentPage = page;
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * page;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
    if(page == 0)
        [self refreshOverviewController];
}

-(void)nextPage{
    int nextPage = self.pageControl.currentPage+1;
    if(nextPage >= self.pageControl.numberOfPages)
        [self changePage:0];
    else
        [self changePage:nextPage];

}

-(void)firstPage{
    [self changePage:0];

}

#pragma mark - Scroll View Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if(!pageControlBeingUsed){
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page == 0 && self.pageControl.currentPage != page)
            [self refreshOverviewController];
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

@end
