//
//  ContactsRequestTableViewController.h
//  BarHopTest
//
//  Created by Tunde Agboola on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"



@interface PlayerRequestViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, FBRequestDelegate> {
	
	NSMutableArray *playersArray;
	NSMutableArray *searchPlayersArray;
	NSArray *invitedPlayers;
    Facebook *facebook;
}

@property (nonatomic,retain)	NSMutableArray *playersArray;
@property (nonatomic,retain)	NSMutableArray *searchPlayersArray;
@property (nonatomic,retain)	NSArray *invitedPlayers;
@property (nonatomic,retain)    Facebook *facebook;

@end
