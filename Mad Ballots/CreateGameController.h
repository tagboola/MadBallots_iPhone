//
//  GameRequestController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"
#import "Player.h"
#import "Game.h"



@interface CreateGameController : UITableViewController <RKObjectLoaderDelegate>{
    int numberOfPlayersAlreadyInvited;
    Game *game;
    NSMutableArray *playersToBeInvited;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *numOfRoundsTextField;
    IBOutlet UITextField *playerInviteTextField;
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *inviteButton;
    IBOutlet UIBarButtonItem *createGameButton;
    IBOutlet UITableViewCell *nameTableViewCell;
    IBOutlet UITableViewCell *roundTableViewCell;
    IBOutlet UITableViewCell *usernameTableViewCell;
    IBOutlet UITableViewCell *facebookTableViewCell;
}
@property (nonatomic,assign) int numberOfPlayersAlreadyInvited;
@property (nonatomic,retain) Game *game;
@property (nonatomic,retain) NSMutableArray *playersToBeInvited;
@property (nonatomic,retain) IBOutlet UITextField *nameTextField;
@property (nonatomic,retain) IBOutlet UITextField *numOfRoundsTextField;
@property (nonatomic,retain) IBOutlet UITextField *playerInviteTextField;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIButton *inviteButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *createGameButton;
@property (nonatomic,retain) IBOutlet UITableViewCell *nameTableViewCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *roundTableViewCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *usernameTableViewCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *facebookTableViewCell;





-(IBAction)inviteButtonClicked:(id) sender;
-(IBAction)createGameButtonClicked:(id) sender;
-(void) invitePlayer:(Player*)player;


@end
