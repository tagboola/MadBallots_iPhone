//
//  TickerViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewWithPaging.h"
#import "RestKit.h"
#import "Contestant.h"

@interface VoteViewController : ScrollViewWithPaging{
    Contestant *contestant;
    NSArray *tickets;
    NSMutableDictionary *viewControllerHash;
    NSMutableDictionary *candidates;
}
@property (nonatomic,retain) Contestant *contestant;
@property (nonatomic,retain) NSArray *tickets;
@property (nonatomic,retain) NSMutableDictionary *viewControllerHash;
@property (nonatomic,retain) NSMutableDictionary *candidates;


-(IBAction)submitButtonClicked:(id)sender;

@end
