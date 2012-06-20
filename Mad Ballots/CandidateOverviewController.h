//
//  CandidateOverviewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface CandidateOverviewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray *candidates;
    UITableView *tableview;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic, retain) NSArray *candidates;
@property (nonatomic, retain) UITableView *tableview;

@end
