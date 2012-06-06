//
//  CandidateViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contestant.h"
#import "ScrollViewWithPaging.h"

@interface CandidateViewController : UIViewController <UITextFieldDelegate>{
    Contestant *contestant;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextField *valueTextField;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic,unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic,retain) Contestant *contestant;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UITextField *valueTextField;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andContestant:(Contestant*)theContestant;

@end
