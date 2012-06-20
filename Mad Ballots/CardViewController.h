//
//  CardViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewWithPaging.h"
#import "RestKit.h"


@interface CardViewController : UIViewController <RKObjectLoaderDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSArray *candidates;
    NSString *cardId;
    NSString *category;
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic,retain) NSArray *candidates;
@property (nonatomic,retain) NSString *cardId;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@end
