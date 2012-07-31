//
//  MBPlayerViewControllerViewController.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"

@interface MBPlayerViewController: UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
    IBOutlet UIButton *commitButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic,retain) IBOutlet UITextField *nameTextField;
@property (nonatomic,retain) IBOutlet UITextField *usernameTextField;
@property (nonatomic,retain) IBOutlet UITextField *emailTextField;
@property (nonatomic,retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic,retain) IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic,retain) IBOutlet UIButton *commitButton;
@property (nonatomic,retain) IBOutlet UIButton *cancelButton;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;


-(IBAction)commitPlayer:(id)sender;
-(IBAction)cancel:(id)sender;


@end
