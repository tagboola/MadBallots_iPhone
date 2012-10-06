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
    BOOL isOwner;
    NSString *contestantId;
    NSString *cardId;
    NSArray *tickets;
    NSMutableDictionary *viewControllerHash;
    NSMutableDictionary *candidatesHash;
    IBOutlet UIBarButtonItem *submitButton;
}
@property (nonatomic,retain) Round *round;
@property (nonatomic,assign) BOOL isOwner;
@property (nonatomic,retain) NSString *contestantId;
@property (nonatomic,retain) NSString *cardId;
@property (nonatomic,retain) NSArray *tickets;
@property (nonatomic,retain) NSMutableDictionary *viewControllerHash;
@property (nonatomic,retain) NSMutableDictionary *candidatesHash;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *submitButton;

-(IBAction)castVoteButtonClicked:(id)sender;

@end
