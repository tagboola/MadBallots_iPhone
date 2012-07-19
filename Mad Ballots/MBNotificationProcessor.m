//
//  MBNotificationProcessor.m
//  Mad Ballots
//
//  Created by Molly Makrogianis on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNotificationProcessor.h"
#import "AppDelegate.h"
#import "MBNotificationActionHandler.h"
#import "MBNotificationActionFillCard.h"
#import "MBNotificationActionVote.h"
#import "MBNotificationActionRSVP.h"

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


-(void)processNotificationAction{
    
    NSDictionary *mbNotificationActionObject = [remoteNotification objectForKey:@"mb_notification_action"];
    NSString * actionIdentifier = [mbNotificationActionObject objectForKey:@"action"];
    NSArray *actionObjectArray = [mbNotificationActionObject objectForKey:@"objects"];
    
    id <MBNotificationActionHandler> notificationHandler = NULL;
    if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_VOTE]){
        notificationHandler = [[MBNotificationActionVote alloc] initWithActionObjects:actionObjectArray];
    }else if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_RSVP]){
        notificationHandler = [[MBNotificationActionRSVP alloc] initWithActionObjects:actionObjectArray];
    }else if ([actionIdentifier isEqualToString:MB_NOTIFICATION_ACTION_IDENTIFIER_FILL_CARD]){
        notificationHandler = [[MBNotificationActionFillCard alloc] initWithActionObjects:actionObjectArray];
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
