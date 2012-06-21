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

@interface GameViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, RKObjectLoaderDelegate>{
    Contestant *contestant;
    NSMutableArray *gameContestants;
    IBOutlet UIToolbar *acceptGameInvitationToolbar;
    IBOutlet UIToolbar *startGameToolbar;
    IBOutlet UIButton *fillCardButton;
    IBOutlet UIButton *voteButton;
    IBOutlet UILabel *gameNameLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *roundLabel;
    IBOutlet UITableView *tableView;
}

@property (nonatomic,retain) IBOutlet UIToolbar *acceptGameInvitationToolbar;
@property (nonatomic,retain) IBOutlet UIToolbar *startGameToolbar;
@property (nonatomic,retain) Contestant *contestant;
@property (nonatomic,retain) NSMutableArray *gameContestants;
@property (nonatomic,retain) IBOutlet UIButton *fillCardButton;
@property (nonatomic,retain) IBOutlet UIButton *voteButton;
@property (nonatomic,retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic,retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic,retain) IBOutlet UILabel *roundLabel;
@property (nonatomic,retain) IBOutlet UITableView *tableView;



-(IBAction)acceptGameInvitation:(id)sender;
-(IBAction)rejectGameInvitation:(id)sender;
-(IBAction)startGame:(id)sender;




@end
