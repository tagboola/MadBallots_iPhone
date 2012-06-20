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

@interface TicketViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    Ticket *ticket;
    NSMutableArray *candidates;
    int selectedIndex;
    NSMutableDictionary *candidateHash;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property(nonatomic,retain) Ticket *ticket;
@property(nonatomic,retain) NSMutableArray *candidates;
@property(nonatomic,retain) NSMutableDictionary *candidateHash;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;

@end
