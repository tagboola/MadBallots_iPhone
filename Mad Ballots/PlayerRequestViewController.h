//
//  ContactsRequestTableViewController.h
//  BarHopTest
//
//  Created by Tunde Agboola on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "RestKit.h"


@interface PlayerRequestViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, FBRequestDelegate,RKObjectLoaderDelegate> {
	NSMutableArray *playersArray;
	NSMutableArray *searchPlayersArray;
	NSMutableArray *selectedPlayersArray;
    NSArray *invitedPlayers;
    Facebook *facebook;
}

@property (nonatomic,retain)	NSMutableArray *playersArray;
@property (nonatomic,retain)	NSMutableArray *searchPlayersArray;
@property (nonatomic,retain)	NSMutableArray *selectedPlayersArray;
@property (nonatomic,retain)	NSArray *invitedPlayers;
@property (nonatomic,retain)    Facebook *facebook;

-(IBAction)addSelectedPlayers:(id)sender;

@end
