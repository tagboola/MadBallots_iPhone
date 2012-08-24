//
//  VoteViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"
#import "ScrollViewWithPaging.h"
#import "Contestant.h"
#import "Candidate.h"
#import "CorePlotHeaders/CorePlot-CocoaTouch.h"
#import "NSMutableArray+getCandidateValue.h"

@interface TicketViewController : MBUIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,CPTBarPlotDataSource>{
    CPTXYGraph *graph;
    int selectedIndex;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic,assign) BOOL isShowingResults;
@property (nonatomic,assign) BOOL isOwner;
@property (nonatomic,retain) NSMutableArray *votes;
@property (nonatomic,retain) Ticket *ticket;
@property (nonatomic,retain) NSMutableArray *candidates;
@property (nonatomic,retain) NSMutableDictionary *candidateHash;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UIToolbar *mergeToolbar;
@property (nonatomic,retain) IBOutlet UIToolbar *mergeInputToolbar;
@property (nonatomic,retain) IBOutlet UITextField *mergeInputToolbarTextfield;
@property (nonatomic,retain) IBOutlet UISegmentedControl *mergeSegmentedControl;


- (void) analyzeCandidates;
- (void) reloadData;
- (IBAction) segmentedControlChanged:(id) sender;
- (IBAction) submitMergeButtonClicked:(id)sender;

@end
