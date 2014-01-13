//
//  MBNotificationProcessor.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNotificationProcessor.h"
#import "AppDelegate.h"
//#import "MBNotificationActionHandler.h"
//#import "MBNotificationActionFillCard.h"
//#import "MBNotificationActionVote.h"
//#import "MBNotificationActionRSVP.h"
#import "MBNotificationActionURL.h"

@interface MBNotificationProcessor (PrivateMethods)

-(void)processNotificationAction;

@end


@implementation MBNotificationProcessor
@synthesize remoteNotification;

-(id)initWithNotification:(NSDictionary *)notification{
    if (self = [super init]){
        remoteNotification = notification;
    }
    return self;
}


-(void)processNotificationWithDialog:(BOOL)showDialog{
    NSString * notificationMsg = [remoteNotification valueForKeyPath:@"aps.alert"];
    if (showDialog){
        [[[UIAlertView alloc] initWithTitle:@"Mad Ballots!" message:notificationMsg delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Go",nil] show];
    }else{
        [self processNotificationAction];
    }
}


/*Notifications come in the form:
 
 aps =     {
    alert = "Welcome to Mad Ballots!";
 };
 "mb_notification_action_action" = url;
 "mb_notification_action_objects" = "http://10.0.1.13:3000/games";
 
 
*/

-(void)processNotificationAction{
    
    /*
     With the usage of the Rails WebApp embedded in a UIWebView, the only action we'll really be passing as an APN is a URL action. I keep the other's in there in case we need to start sending JSON objects again.
     */
    
    
    //NSDictionary *mbNotificationActionObject = [remoteNotification objectForKey:@"mb_notification_action"];
    NSString * actionIdentifier = [remoteNotification objectForKey:@"mb_notification_action"];
    NSArray * actionObjectArray = [NSArray arrayWithObject:[remoteNotification objectForKey:@"mb_notification_object"]];
    
    
    
    id <MBNotificationActionHandler> notificationHandler = NULL;
    if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_VOTE]){
        //notificationHandler = [[MBNotificationActionVote alloc] initWithActionObjects:actionObjectArray];
    }else if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_RSVP]){
        //notificationHandler = [[MBNotificationActionRSVP alloc] initWithActionObjects:actionObjectArray];
    }else if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_FILL_CARD]){
        //notificationHandler = [[MBNotificationActionFillCard alloc] initWithActionObjects:actionObjectArray];
    }else if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_URL]){
        notificationHandler = [[MBNotificationActionURL alloc] initWithActionObjects:actionObjectArray];
    }
    [notificationHandler execute];

}


#pragma mark Remote Notification Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){ //process the notification action
        [self processNotificationAction];
    }
}



@end
