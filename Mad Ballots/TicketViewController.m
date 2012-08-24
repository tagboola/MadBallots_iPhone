//
//  VoteViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TicketViewController.h"
#import "Ballot.h"

#define VOTE_SEGMENT_INDEX 0
#define MERGE_SEGMENT_INDEX 1
#define MULTIPLE_SELECT_EDITING_STYLE 3

@implementation TicketViewController
@synthesize mergeToolbar;
@synthesize mergeInputToolbar;
@synthesize mergeInputToolbarTextfield;
@synthesize isShowingResults;
@synthesize isOwner;
@synthesize votes;
@synthesize delegate;
@synthesize ticket;
@synthesize candidates;
@synthesize tableView;
@synthesize titleLabel;
@synthesize imageView;
@synthesize candidateHash;
@synthesize mergeSegmentedControl;





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void) reloadData{
    [tableView reloadData];
    if(!isShowingResults)
        return;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/tickets/%@/ballots.json",ticket.ticketId] usingBlock:^(RKObjectLoader *loader) {
        [self startLoading:@"Loading results..."];
        loader.onDidLoadObjects = ^(NSArray * objects){
            [self stopLoading];
            self.votes = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0],nil];
            for(Ballot *ballot in objects){
                for(int ii = 0; ii < [candidates count]; ii++){
                    Candidate *candidate = [candidates objectAtIndex:ii];
                    if([ballot.candidateId isEqualToString:candidate.candidateId]){
                        NSNumber *vote = [votes objectAtIndex:ii];
                        vote = [NSNumber numberWithInt:([vote integerValue]+1)];
                        [votes replaceObjectAtIndex:ii withObject:vote];
                    }
                    
                }
            }
            CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.tableView.bounds];
            hostingView.backgroundColor = [UIColor grayColor];
            graph = [[CPTXYGraph alloc] initWithFrame: hostingView.bounds];
            
            hostingView.hostedGraph = graph;
            graph.plotAreaFrame.paddingLeft	  = 30.0;
            graph.plotAreaFrame.paddingRight  = 50.0;
            graph.plotAreaFrame.paddingTop = 10.0;

            
            CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
            plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                            length:CPTDecimalFromFloat([candidates count])];
            plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                            length:CPTDecimalFromFloat([candidates count])];
            
            // Line styles
            CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
            axisLineStyle.lineWidth = 3.0;
            
            CPTMutableLineStyle *majorTickLineStyle = [axisLineStyle mutableCopy];
            majorTickLineStyle.lineWidth = 3.0;
            majorTickLineStyle.lineCap	 = kCGLineCapRound;
            
            CPTMutableLineStyle *minorTickLineStyle = [axisLineStyle mutableCopy];
            minorTickLineStyle.lineWidth = 2.0;
            minorTickLineStyle.lineCap	 = kCGLineCapRound;
            
            // Text styles
            CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
            axisTitleTextStyle.fontName = @"Marker Felt";
            axisTitleTextStyle.fontSize = 14.0;
            
            
            CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
            axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
            axisSet.xAxis.majorIntervalLength = CPTDecimalFromInt([candidates count]);
            axisSet.xAxis.titleTextStyle	= axisTitleTextStyle;

            NSMutableArray *labels = [NSMutableArray array];
            int maxLabelHeight = 0;
            for(int ii = 0; ii < [candidates count]; ii++){
                Candidate *candidate = [candidates objectAtIndex:ii];
                CPTAxisLabel *label; 
                label = [[CPTAxisLabel alloc] initWithText:candidate.value textStyle:axisSet.xAxis.labelTextStyle];
                
                label.tickLocation = CPTDecimalFromFloat(ii+.5);
                label.offset = 5;
                [labels addObject:label];
                maxLabelHeight = label.contentLayer.bounds.size.width+label.offset > maxLabelHeight ? label.contentLayer.bounds.size.width+label.offset : maxLabelHeight;
            }
            
            graph.plotAreaFrame.paddingBottom = maxLabelHeight;
            axisSet.xAxis.axisLabels = [NSSet setWithArray:labels];
            axisSet.xAxis.labelRotation = M_PI/4;
            axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
            NSNumberFormatter *yAxisFormatter = [[NSNumberFormatter alloc] init];
            [yAxisFormatter setMaximumFractionDigits:0];
            axisSet.yAxis.labelFormatter = yAxisFormatter;
            axisSet.yAxis.minorTicksPerInterval = 0;
            axisSet.yAxis.majorIntervalLength = CPTDecimalFromInt(1);
            axisSet.yAxis.majorTickLineStyle = majorTickLineStyle;
            
            
            CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
            barPlot.barOffset = CPTDecimalFromFloat(0.5);
            barPlot.identifier = @"Graph";
            barPlot.dataSource = self;
            [graph addPlot:barPlot];
            [self.tableView addSubview:hostingView];
            
        };
        loader.onDidFailWithError = ^(NSError *error){
            [self stopLoading];
            NSLog(@"Error loading ballots for ticket:%@",[error localizedDescription]);
        };
    }];
    

}

-(void)updateCandidates:(CandidateGroup*)candidateGroup{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    for(NSIndexPath *indexPath in selectedRows){
        NSArray *candidateArray = [candidates objectAtIndex:indexPath.row];
        for(Candidate *candidate in candidateArray){
            candidate.candidateGroupId = candidateGroup.candidateGroupId;
            candidate.candidateGroup = candidateGroup;
            [[RKObjectManager sharedManager] putObject:candidate usingBlock:^(RKObjectLoader *loader) {
                loader.onDidLoadObjects = ^(NSArray *objects){
                    if(loader.queue.count == 1){
                        [self stopLoading];
                        [self.mergeSegmentedControl setSelectedSegmentIndex:VOTE_SEGMENT_INDEX];
                        [self segmentedControlChanged:mergeSegmentedControl];
                        [self analyzeCandidates];
                    }
                };
                loader.onDidFailWithError = ^(NSError *error){
                    [self stopLoading];
                    NSLog(@"Error POST-ing CandidateGroup:%@",[error localizedDescription]);
                };
            }];
        }
    }
    
}

-(IBAction) submitMergeButtonClicked:(id)sender{
    [mergeInputToolbarTextfield resignFirstResponder];
    if(mergeInputToolbarTextfield.text == nil || mergeInputToolbarTextfield.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:@"Invalid merged name" message:@"Please enter a name to merge the two candidates too in the field below" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    if([selectedRows count] <= 1){
        [[[UIAlertView alloc] initWithTitle:@"Minimum of two candidates" message:@"Please select atleast two candidates to perform a merge" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    [self startLoading:@"Merging candidates..."];
    CandidateGroup *candGroup = [[CandidateGroup alloc] init];
    candGroup.value = mergeInputToolbarTextfield.text;
    [[RKObjectManager sharedManager] postObject:candGroup usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *objects){
            [self updateCandidates:[objects objectAtIndex:0]];
        };
        loader.onDidFailWithError = ^(NSError *error){
            [self stopLoading];
            NSLog(@"Error POST-ing CandidateGroup:%@",[error localizedDescription]);
        };
    }];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndex = -1;
    self.candidates = [NSMutableArray array];
    self.titleLabel.text = ticket.player.name;
    //TODO: Put player's image 
    self.imageView.image = [UIImage imageNamed:@"default_list_user.png"];
    
    UISwipeGestureRecognizer *fingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [fingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:fingerSwipeLeft];
    UISwipeGestureRecognizer *fingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [fingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:fingerSwipeRight];
    
    if(isOwner){
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height- self.mergeToolbar.frame.size.height);
        self.mergeToolbar.frame = CGRectMake(0, self.view.frame.size.height-self.mergeToolbar.frame.size.height, self.view.frame.size.width, self.mergeToolbar.frame.size.height);
    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) analyzeCandidates{
    //Match candidates with the same case insensitive value
    NSMutableDictionary *valueMatchedCandidatesHash = [NSMutableDictionary dictionary];
    NSMutableDictionary *candidateGroupMatchedCandidatesHash = [NSMutableDictionary dictionary];
    NSMutableDictionary *valueHash = [NSMutableDictionary dictionary];
    NSMutableDictionary *candidateGroupHash = [NSMutableDictionary dictionary];
    for(NSArray *candidateArray in candidates){
        for(Candidate *candidate in candidateArray){ 
            NSString *uppercaseValue = [candidate.value uppercaseString];
            if([valueHash objectForKey:uppercaseValue]){
                NSMutableArray *matchedCandidates = [valueMatchedCandidatesHash objectForKey:uppercaseValue];
                [matchedCandidates addObject:candidate];
                [valueMatchedCandidatesHash setObject:matchedCandidates forKey:uppercaseValue];
                
            }else if(candidate.candidateGroup && [candidateGroupHash objectForKey:candidate.candidateGroup.candidateGroupId]){
                NSMutableArray *matchedCandidates = [candidateGroupMatchedCandidatesHash objectForKey:candidate.candidateGroup.candidateGroupId];
                [matchedCandidates addObject:candidate];
                [candidateGroupMatchedCandidatesHash setObject:matchedCandidates forKey:candidate.candidateGroup.candidateGroupId];
            }
            else if(candidate.candidateGroup){
                [candidateGroupHash setObject:candidate forKey:candidate.candidateGroup.candidateGroupId];
                [candidateGroupMatchedCandidatesHash setObject:[NSMutableArray arrayWithObject:candidate] forKey:candidate.candidateGroup.candidateGroupId];
            }
            else{        
                [valueHash setObject:candidate forKey:uppercaseValue];
                [valueMatchedCandidatesHash setObject:[NSMutableArray arrayWithObject:candidate] forKey:uppercaseValue];
            }
        }
    }
    self.candidates = [NSMutableArray arrayWithArray:[valueMatchedCandidatesHash allValues]];
    [self.candidates addObjectsFromArray:[candidateGroupMatchedCandidatesHash allValues]];
    [self reloadData];
}

- (void) swipeLeft{
    [delegate nextPage];

}

- (void) swipeRight{
    [delegate previousPage];
}

- (IBAction) segmentedControlChanged:(id) sender{
    if(((UISegmentedControl*)sender).selectedSegmentIndex == VOTE_SEGMENT_INDEX){
        self.tableView.editing = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height- self.mergeToolbar.frame.size.height);
        self.mergeToolbar.frame = CGRectMake(0, self.view.frame.size.height-self.mergeToolbar.frame.size.height, self.view.frame.size.width, self.mergeToolbar.frame.size.height);
        self.mergeInputToolbar.frame = CGRectMake(0, self.view.frame.size.height/*+self.mergeInputToolbar.frame.size.height*/, self.view.frame.size.width, self.mergeToolbar.frame.size.height);        
        [UIView commitAnimations];
    }else{
        self.tableView.editing = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDidStopSelector:@selector(animationEnded)];
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.mergeToolbar.frame.size.height*2);
        self.mergeToolbar.frame = CGRectMake(0, self.view.frame.size.height-self.mergeToolbar.frame.size.height*2, self.view.frame.size.width, self.mergeToolbar.frame.size.height);
        self.mergeInputToolbar.frame = CGRectMake(0, self.view.frame.size.height-self.mergeInputToolbar.frame.size.height, self.view.frame.size.width, self.mergeToolbar.frame.size.height);        
        [UIView commitAnimations];
    }
}


//- (void) animationEnded{
//    self.mergeInputToolbar.frame = CGRectMake(0, self.view.frame.size.height+self.mergeInputToolbar.frame.size.height, self.view.frame.size.width, self.mergeToolbar.frame.size.height); 
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [candidates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //TODO: Include logic to use a particular version of the grouped candidates value
    cell.textLabel.text = [(NSMutableArray*)[candidates objectAtIndex:indexPath.row] getCandidateValue];;
    
    if(selectedIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return MULTIPLE_SELECT_EDITING_STYLE;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.tableView.isEditing){
        selectedIndex = indexPath.row;
        NSArray *selectedCandidates =  [candidates objectAtIndex:selectedIndex];
        [candidateHash setObject:selectedCandidates forKey:ticket.contestantId];
        [self reloadData];
        [delegate nextPage];
    }
}

#pragma mark Object loader delegate methods

//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//    NSLog(@"Did get objects: %@", objects);
//    self.candidates = objects;
//    [self.tableView reloadData];
//    
//}
//
//- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
//    NSLog(@"Object Loader failed with error: %@", [error localizedDescription]);
//}

#pragma mark Text Field delegate methods


//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [delegate controlSelectedForEditing:mergeInputToolbar];
//    
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [delegate editingFinished];
    return YES;
}

#pragma mark Bar Plot data source methods

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum 
			   recordIndex:(NSUInteger)index;
{
    NSNumber *vote = [votes objectAtIndex:index];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [NSNumber numberWithInt:index];
            break;
        case CPTScatterPlotFieldY:
            return vote;
            break;
        default:
            return [NSNumber numberWithInteger:-1];
    }
}

- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot{
    return [candidates count];
}

@end
