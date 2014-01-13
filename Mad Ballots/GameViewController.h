//
//  GameViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contestant.h"
#import "RestKit.h"

@interface GameViewController : MBUIViewController <UITableViewDataSource,UITableViewDelegate, RKObjectLoaderDelegate>{
    Contestant *contestant;
    NSMutableArray *gameContestants;
    NSArray *rounds;
    IBOutlet UIToolbar *acceptGameInvitationToolbar;
    IBOutlet UIToolbar *startGameToolbar;
    IBOutlet UIButton *fillCardButton;
    IBOutlet UIButton *voteButton;
    IBOutlet UILabel *gameNameLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *roundLabel;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *previousRoundStatusLabel;
    IBOutlet UIBarButtonItem *addPlayerButton;
}

@property (nonatomic,retain) IBOutlet UIToolbar *acceptGameInvitationToolbar;
@property (nonatomic,retain) IBOutlet UIToolbar *startGameToolbar;
@property (nonatomic,retain) Contestant *contestant;
@property (nonatomic,retain) NSMutableArray *gameContestants;
@property (nonatomic,retain) NSArray *rounds;
@property (nonatomic,retain) IBOutlet UIButton *fillCardButton;
@property (nonatomic,retain) IBOutlet UIButton *voteButton;
@property (nonatomic,retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic,retain) IBOutlet UILabel *roundLabel;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *previousRoundStatusLabel;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *addPlayerButton;





-(IBAction)acceptGameInvitation:(id)sender;
-(IBAction)rejectGameInvitation:(id)sender;
-(IBAction)startGame:(id)sender;
-(IBAction)fillCard:(id)sender;
-(IBAction)castVote:(id)sender;
-(IBAction)viewResults:(id)sender;
-(IBAction)addPlayers:(id)sender;



@end
