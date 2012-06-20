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
    NSArray *tickets;
    NSMutableDictionary *candidates;
}
@property (nonatomic, unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic, retain) NSArray *tickets;
@property (nonatomic, retain) NSMutableDictionary *candidates;
@end
