//
//  MBRootNavigationViewController.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBRootNavigationController.h"
#import "AppDelegate.h"

@implementation MBRootNavigationController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    /*if (![[AppDelegate getInstance] isAuthenticated]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
    }*/
}




@end
