//
//  MasterViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"



@interface GamesViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RKObjectLoaderDelegate>{
    NSArray *gamesArray;
    NSArray *sectionTitleArray;
}

@property (nonatomic,retain) NSArray *gamesArray;
@property (nonatomic,retain) NSArray *sectionTitleArray;






@end
