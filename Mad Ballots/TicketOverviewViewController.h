//
//  BallotOverviewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewWithPaging.h"

@interface TicketOverviewViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>{
//    BOOL isOwner;
    BOOL isShowingResults;
//    NSArray *tickets;
//    NSMutableDictionary *candidates;
//    IBOutlet UIToolbar *mergeCandidates;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic, retain) NSArray *tickets;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, retain) NSMutableDictionary *candidates;




- (id)initWithStyle:(UITableViewStyle)style showResults:(BOOL)showResults tickets:(NSArray*)theTickets candidates:(NSMutableDictionary*)theCandidates delegate:(ScrollViewWithPaging*)theDelegate;
- (IBAction) segmentedControlChanged:(id) sender;
- (IBAction) submitButtonClicked:(id)sender;
@end
