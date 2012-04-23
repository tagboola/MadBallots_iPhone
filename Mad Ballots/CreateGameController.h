//
//  GameRequestController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"


@interface CreateGameController : UITableViewController <RKObjectLoaderDelegate>{
    
    NSMutableArray *invitedPlayers;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *numOfRoundsTextField;
    IBOutlet UITextField *playerInviteTextField;
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *inviteButton;
    IBOutlet UIBarButtonItem *createGameButton;


}


@property (nonatomic,retain) NSMutableArray *invitedPlayers;
@property (nonatomic,retain) IBOutlet UITextField *nameTextField;
@property (nonatomic,retain) IBOutlet UITextField *numOfRoundsTextField;
@property (nonatomic,retain) IBOutlet UITextField *playerInviteTextField;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIButton *inviteButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *createGameButton;





-(IBAction)inviteButtonClicked:(id) sender;
-(IBAction)createGameButtonClicked:(id) sender;
@end
