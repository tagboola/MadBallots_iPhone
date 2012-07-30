//
//  MBUIViewController.h
//  Mad Ballots
//
//  Created by Tunde Agboola on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBUIViewController : UIViewController{
    BOOL isLoading;
}

-(void)startLoading:(NSString*)labelText;
-(void)stopLoading;

@end
