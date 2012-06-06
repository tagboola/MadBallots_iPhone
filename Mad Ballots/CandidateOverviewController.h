//
//  CardViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface CandidateOverviewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    NSArray *contestants;
    IBOutlet UITableView *tableView;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic, retain) NSArray *contestants;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


@end
