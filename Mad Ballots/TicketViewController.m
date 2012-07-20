//
//  VoteViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TicketViewController.h"
#import "Ballot.h"


@implementation TicketViewController

@synthesize votes;
@synthesize delegate;
@synthesize ticket;
@synthesize candidates;
@synthesize tableView;
@synthesize titleLabel;
@synthesize imageView;
@synthesize candidateHash;



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) reloadData{
    [tableView reloadData];
    //Testing plots
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/tickets/%@/ballots.json",ticket.ticketId] usingBlock:^(RKObjectLoader *loader) {

        loader.onDidLoadObjects = ^(NSArray * objects){
            self.votes = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0],nil];
//            int maxVotes = -1;
//            int maxIndex;
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
//            Candidate *winner = [candidates objectAtIndex:maxIndex];
//            [self.candidates setValue:winner forKey:ticket.contestantId];
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
            NSLog(@"Error loading ballots for ticket:%@",[error localizedDescription]);
        };
    }];
    

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    selectedIndex = -1;
//    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/rounds/%@/candidates.json?query=candidates.contestant_id=%@",contestant.round.roundId,contestant.contestantId]  delegate:self];
    self.candidates = [NSMutableArray array];
    self.titleLabel.text = ticket.player.name;
    //TODO: Put player's image 
    self.imageView.image = [UIImage imageNamed:@"default_list_user.png"];
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
    
    Candidate *candidate = [candidates objectAtIndex:indexPath.row];
    cell.textLabel.text = candidate.value;
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    NSSet *set = [NSSet setWithObject:[candidates objectAtIndex:selectedIndex]];
    [candidateHash setObject:set forKey:ticket.contestantId];
    [self.tableView reloadData];
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
