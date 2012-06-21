//
//  CandidateViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "ScrollViewWithPaging.h"

@interface CandidateViewController : UIViewController <UITextFieldDelegate>{
    Candidate *candidate;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextField *valueTextField;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic,unsafe_unretained) id <ScrollViewWithPagingDelegate> delegate;
@property (nonatomic,retain) Candidate *candidate;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UITextField *valueTextField;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCandidate:(Candidate*)theCandidate;

@end
