//
//  CandidateViewController.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CandidateViewController.h"

@implementation CandidateViewController

@synthesize delegate;
@synthesize contestant;
@synthesize nameLabel;
@synthesize valueTextField;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andContestant:(Contestant*)theContestant
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.contestant = theContestant;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = contestant.player.name;
    //TODO Add user's image to imageView
    self.imageView.image = [UIImage imageNamed:@"default_list_user.png"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Texfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField.returnKeyType == UIReturnKeyNext)
        [delegate nextPage];
    else if(textField.returnKeyType == UIReturnKeyDone)
        [delegate firstPage];
    return NO;
}

@end
