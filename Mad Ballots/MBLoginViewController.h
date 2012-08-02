//
//  MBLoginViewController.h
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit.h"
#import "Facebook.h"


@interface MBLoginViewController : UIViewController <RKObjectLoaderDelegate,FBRequestDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *usernameTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passwordTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)login:(UIButton *)sender;
- (IBAction)loginWithFacebook:(UIButton *)sender;
- (IBAction)createAccount:(UIButton *)sender;

@end
