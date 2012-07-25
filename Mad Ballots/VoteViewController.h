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
    Round *round;
    NSString *contestantId;
    NSString *cardId;
    NSArray *tickets;
    NSMutableDictionary *viewControllerHash;
    NSMutableDictionary *candidates;
}
@property (nonatomic,retain) Round *round;
@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *cardId;
@property (nonatomic,retain) NSArray *tickets;
@property (nonatomic,retain) NSMutableDictionary *viewControllerHash;
@property (nonatomic,retain) NSMutableDictionary *candidates;


-(IBAction)submitButtonClicked:(id)sender;

@end
