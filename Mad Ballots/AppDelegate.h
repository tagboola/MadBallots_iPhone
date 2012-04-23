//
//  AppDelegate.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "RestKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate,FBRequestDelegate,RKObjectLoaderDelegate>{
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Facebook *facebook;

-(void) loginToFacebook;

@end
