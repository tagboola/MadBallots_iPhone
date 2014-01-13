//
//  MBNotificationActionURL.m
//  Mad Ballots
//
//  Created by Jeremy Clark on 1/4/14.
//
//

#import "MBNotificationActionURL.h"

@class AppDelegate;

@implementation MBNotificationActionURL

-(void)execute{
    
    //Get the "target url"
    if (self.actionObjects.count > 0){
        NSString * targetPath = [self.actionObjects objectAtIndex:0];
        NSString * targetURLStr = [BASE_URL stringByAppendingString:targetPath];
        NSURL * targetURL = [NSURL URLWithString:targetURLStr];
        NSURLRequest * targetRequest = [NSURLRequest requestWithURL:targetURL];
        [[AppDelegate webAppView] loadRequest:targetRequest];
    }
    
}

@end
